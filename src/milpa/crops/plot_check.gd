## Verificación de las parcelas (criterios de ISS-17). No es autoload. Ejecutar con:
## godot --headless --path . --script res://src/milpa/crops/plot_check.gd
## Termina con código 0 si todo pasa y con 1 si algo falla.
extends SceneTree

enum Phase { MORNING, AFTERNOON, DUSK, NIGHT, DAWN } ## Mismo orden que GameState.Phase.

const MAIN_SCENE: String = "res://src/main.tscn"

var _failures: int = 0
var _state: Node
var _bus: Node
var _errors: ErrorCounter = ErrorCounter.new()
var _planted_cell: Vector2i = Vector2i(-1, -1)


func _initialize() -> void:
	# Este script se compila antes que los autoloads y no puede nombrarlos.
	_state = root.get_node(^"GameState")
	_bus = root.get_node(^"EventBus")
	OS.add_logger(_errors)
	_bus.crop_planted.connect(func(_id: StringName, cell: Vector2i) -> void: _planted_cell = cell)
	_run.call_deferred()


func _run() -> void:
	change_scene_to_file(MAIN_SCENE)
	await process_frame
	await process_frame
	var plots: Array[Node] = _plots()
	_expect(plots.size() == 9, "hay 9 parcelas (%d)" % plots.size())
	var a: Node = plots[0]
	var b: Node = plots[1]
	var player: Node = get_first_node_in_group(&"player")

	# --- Sembrar ---
	_expect(_state.inventory[&"maize_seed"] == 5, "empieza con 5 maize_seed")
	player.active_tool = &"maize_seed"
	_use(a, player)
	_expect(a.state[&"crop"] == &"maize", "E con maize_seed siembra maíz")
	_expect(_state.inventory[&"maize_seed"] == 4, "quedan 4 semillas")
	_expect(a.is_in_group(&"crops"), "la parcela sembrada está en el grupo crops")
	var ground: TileMapLayer = current_scene.find_child("ground", true, false)
	_expect(_planted_cell == ground.local_to_map(ground.to_local(a.global_position)),
			"crop_planted envía la celda del tilemap (%s)" % _planted_cell)
	_state.inventory[&"maize_seed"] = 0
	_use(b, player)
	_expect(b.state[&"crop"] == &"", "sin semillas no siembra")
	_expect(not b.is_in_group(&"crops"), "la parcela vacía no está en el grupo crops")
	_state.inventory[&"maize_seed"] = 4

	# --- Regar ---
	player.active_tool = &"water_jar"
	var water: int = _state.water
	_use(a, player)
	_expect(_state.water == water - 10, "regar maíz gasta exactamente 10")
	_use(a, player)
	_expect(_state.water == water - 10, "regar otra vez el mismo día no gasta agua")
	player.active_tool = &"maize_seed"
	_use(b, player)
	player.active_tool = &"water_jar"
	_state.water = 9
	_use(b, player)
	_expect(_state.water == 9 and not b.state[&"watered"], "con menos de 10 de agua no se riega")

	# --- Crecimiento y cuadro (a se riega los días 1, 2 y 3; b nunca) ---
	var frame: int = a.get_node(^"Sprite2D").frame
	_expect(frame == 0, "día 1: cuadro de semilla")
	await _to_next_morning() # Amanecer 1: a crece, b lleva 1 día seco.
	_expect(_state.day == 2 and a.state[&"growth"] == 1, "día 2: maíz con growth 1")
	_expect(a.get_node(^"Sprite2D").frame == 1, "el cuadro cambia al amanecer (brote)")
	_expect(b.state[&"crop"] == &"maize", "1 amanecer sin riego no lo seca")
	_use(a, player)
	await _to_next_morning() # Amanecer 2: b se seca.
	_expect(b.state[&"crop"] == &"", "2 amaneceres sin riego: la parcela queda vacía")
	_expect(not b.get_node(^"Sprite2D").visible, "la parcela seca no muestra cultivo")
	_use(a, player)
	await _to_next_morning()
	_expect(_state.day == 4 and a.state[&"growth"] == 3, "día 4: maíz maduro")
	_expect(a.get_node(^"Sprite2D").frame == 3, "cuadro maduro")

	# --- Fuera de la Mañana, E no hace nada ---
	_advance() # Tarde
	var maize: int = _state.inventory.get(&"maize", 0)
	_use(a, player)
	_expect(a.state[&"crop"] == &"maize", "en la Tarde no se cosecha")
	player.active_tool = &"maize_seed"
	_use(plots[2], player)
	_expect(plots[2].state[&"crop"] == &"", "en la Tarde no se siembra")

	# --- Muerte y recarga: vuelve al snapshot de la Mañana del día 4 ---
	_bus.player_died.emit()
	await process_frame
	await process_frame
	plots = _plots()
	a = plots[0]
	player = get_first_node_in_group(&"player")
	_expect(_state.phase == Phase.MORNING and _state.day == 4, "tras player_died vuelve a la Mañana del día 4")
	_expect(a.state[&"crop"] == &"maize" and a.state[&"growth"] == 3, "la parcela vuelve al snapshot")
	_expect(a.get_node(^"Sprite2D").frame == 3, "tras la recarga se ve madura")

	# --- Cosechar con cualquier herramienta ---
	player.active_tool = &"spear"
	_use(a, player)
	var gained: int = _state.inventory.get(&"maize", 0) - maize
	_expect(gained >= 3 and gained <= 5, "cosecha suma entre 3 y 5 maize (%d)" % gained)
	_expect(a.state[&"crop"] == &"", "tras cosechar la parcela queda vacía")

	# --- Golpe real de criatura (hitbox ENEMY) que deja la vida en 0 ---
	player.active_tool = &"maize_seed"
	_use(a, player)
	await physics_frame # La hurtbox se activa diferida.
	var hit: HitboxComponent = _enemy_hitbox(a.global_position, a.get_node(^"HealthComponent").current_health)
	for i: int in 3:
		await physics_frame
	_expect(a.state[&"crop"] == &"", "un golpe de criatura que deja la vida en 0 vacía la parcela")
	# Termina la invulnerabilidad con la hurtbox ya apagada: no debe dar error del motor.
	await create_timer(a.get_node(^"HurtboxComponent").invulnerability_time + 0.1).timeout
	hit.queue_free()
	await physics_frame

	# --- growth_days desde el .tres ---
	var beans: Resource = load("res://data/crops/beans.tres") # Misma instancia en caché que usa Plot.
	beans.growth_days = 1
	_state.inventory[&"beans_seed"] = 1
	player.active_tool = &"beans_seed"
	_use(a, player)
	player.active_tool = &"water_jar"
	_use(a, player)
	await _to_next_morning()
	_expect(a.state[&"growth"] >= beans.growth_days, "frijol maduro en %d día con growth_days cambiado" % beans.growth_days)

	_expect(_errors.count == 0, "sin errores del motor (%d)" % _errors.count)
	if _failures == 0:
		print("plot_check OK")
		quit(0)
	else:
		printerr("plot_check: %d caso(s) fallaron" % _failures)
		quit(1)


func _plots() -> Array[Node]:
	var plots: Array[Node] = []
	for marker: Node in get_nodes_in_group(&"plots"):
		plots.append(marker.get_child(0))
	return plots


## Simula E del jugador sobre la parcela.
func _use(plot: Node, player: Node) -> void:
	plot.get_node(^"InteractableComponent").interacted.emit(player)


## Hitbox de criatura sobre una parcela, como la del Wáay Pek'.
func _enemy_hitbox(at: Vector2, damage: int) -> HitboxComponent:
	var hitbox: HitboxComponent = HitboxComponent.new()
	hitbox.team = HitboxComponent.Team.ENEMY
	hitbox.damage = damage
	var shape: CollisionShape2D = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	hitbox.add_child(shape)
	hitbox.position = at
	current_scene.add_child(hitbox)
	return hitbox


func _advance() -> void:
	get_first_node_in_group(&"day_cycle").advance_phase()


func _to_next_morning() -> void:
	while true:
		_advance()
		if _state.phase == Phase.MORNING:
			break
	await process_frame


func _expect(ok: bool, label: String) -> void:
	if not ok:
		_failures += 1
		printerr("FALLA: " + label)


## Cuenta los errores del motor (no las advertencias) para que también hagan fallar la verificación.
class ErrorCounter extends Logger:
	var count: int = 0

	func _log_error(_function: String, _file: String, _line: int, _code: String, _rationale: String,
			_editor_notify: bool, error_type: int, _script_backtraces: Array[ScriptBacktrace]) -> void:
		if error_type != ERROR_TYPE_WARNING:
			count += 1
