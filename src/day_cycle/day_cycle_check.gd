## Verificación de DayCycle con level_01 (criterios de ISS-10). No es autoload. Ejecutar con:
## godot --headless --path . --fixed-fps 60 --script res://src/day_cycle/day_cycle_check.gd
## Con --fixed-fps el juego avanza en tiempo simulado: los 5 días tardan unos segundos.
## Termina con código 0 si todo pasa y con 1 si algo falla.
extends SceneTree

enum Phase { MORNING, AFTERNOON, DUSK, NIGHT, DAWN } ## Mismo orden que GameState.Phase.

const TOLERANCE: float = 0.5 ## s.
const MAIN_SCENE: String = "res://src/main.tscn"

var _failures: int = 0
var _elapsed: float = 0.0 ## Tiempo de juego desde el inicio (s).
var _state: Node
var _bus: Node
var _phase_log: Array[Array] = [] ## [fase, día, segundo]
var _day_log: Array[Array] = [] ## [día emitido, GameState.day]
var _last_water_event: Array = []


func _initialize() -> void:
	# Este script se compila antes que los autoloads y no puede nombrarlos.
	_state = root.get_node(^"GameState")
	_bus = root.get_node(^"EventBus")
	_bus.phase_changed.connect(_on_phase_changed)
	_bus.day_started.connect(func(day: int) -> void: _day_log.append([day, _state.day]))
	_bus.water_changed.connect(
		func(current: int, maximum: int) -> void: _last_water_event = [current, maximum]
	)
	_run.call_deferred()


func _process(delta: float) -> bool:
	_elapsed += delta
	return false


func _run() -> void:
	change_scene_to_file(MAIN_SCENE)
	var level: Resource = load("res://data/levels/level_01.tres")
	var durations: Array[float] = [
		level.morning_duration, level.afternoon_duration, level.dusk_duration,
		level.night_duration, level.dawn_duration,
	]

	# --- Día 1 completo con el temporizador ---
	_expect(await _wait_phase(Phase.MORNING, 1, 5.0), "arranca en la Mañana del día 1")
	_expect(_state.water == level.max_water, "día 1: agua llena")
	_expect(_state.cacao == level.starting_cacao, "día 1: cacao inicial")
	_expect(_state.inventory == level.starting_inventory, "día 1: inventario inicial")
	_expect(_state.use_water(40), "día 1: se puede gastar agua")
	_expect(await _wait_phase(Phase.MORNING, 2, 400.0), "llega la Mañana del día 2")
	for i: int in 5:
		var measured: float = _phase_log[i + 1][2] - _phase_log[i][2]
		_expect(
			absf(measured - durations[i]) <= TOLERANCE,
			"fase %d dura %.1f s (esperado %.1f)" % [i, measured, durations[i]]
		)
	_expect(_day_log == [[1, 1], [2, 2]], "day_started(1) y (2) con GameState.day igual: %s" % [_day_log])

	# --- Muerte en la Noche del día 2 ---
	await process_frame
	var saved: Dictionary = {
		&"water": _state.water,
		&"cacao": _state.cacao,
		&"inventory": _state.inventory.duplicate(),
		&"world": _state.world.duplicate(true),
	}
	_state.add_item(&"maize", 3)
	_state.add_cacao(-5)
	_state.use_water(30)
	_state.world[&"plots"] = [{&"crop": &"maize", &"growth": 1}]
	_expect(await _wait_phase(Phase.NIGHT, 2, 300.0), "llega la Noche del día 2")
	var old_scene: Node = current_scene
	var deaths_at: int = _phase_log.size()
	_bus.player_died.emit()
	_bus.player_died.emit() # La segunda se ignora: ya se está recargando.
	_expect(await _wait_phase(Phase.MORNING, 2, 5.0), "tras player_died vuelve a la Mañana del día 2")
	_expect(_phase_log.size() == deaths_at + 1, "la recarga emite una sola Mañana")
	_expect(current_scene != old_scene and is_instance_valid(current_scene), "la escena se recargó")
	_expect(get_nodes_in_group(&"day_cycle").size() == 1, "queda un solo DayCycle")
	_expect(_state.water == saved[&"water"], "restore: agua")
	_expect(_state.cacao == saved[&"cacao"], "restore: cacao")
	_expect(_state.inventory == saved[&"inventory"], "restore: inventario")
	_expect(_state.world == saved[&"world"], "restore: world")
	_expect(_day_log.back() == [2, 2], "day_started(2) tras la recarga")

	# --- F2 (debug_skip_phase) hasta la Noche del jefe ---
	var boss_night: int = level.boss_night
	var guard: int = 0
	while not (_state.day == boss_night and _state.phase == Phase.NIGHT) and guard < 50:
		var before: int = _phase_log.size()
		_press_f2()
		await process_frame
		_expect(_phase_log.size() == before + 1, "F2 emite un solo phase_changed")
		guard += 1
	_expect(_state.day == boss_night and _state.phase == Phase.NIGHT, "F2 llega a la Noche %d" % boss_night)
	for entry: Array in _day_log:
		_expect(entry[0] == entry[1], "day_started(%d) con GameState.day %d" % [entry[0], entry[1]])
	_expect(_phase_sequence_ok(), "las fases siguen el orden y no se repiten: %s" % [_phase_log])

	# --- Noche del jefe: sin temporizador, termina con wave_cleared ---
	var cycle: Node = get_first_node_in_group(&"day_cycle")
	_expect(cycle.time_left() == 0.0 and cycle.phase_duration() == 0.0, "Noche del jefe sin límite")
	await create_timer(level.night_duration + 30.0).timeout
	_expect(_state.phase == Phase.NIGHT, "la Noche del jefe no termina por tiempo")
	_bus.wave_cleared.emit(boss_night - 1)
	await process_frame
	_expect(_state.phase == Phase.NIGHT, "wave_cleared de otra noche no la termina")
	_state.use_water(50)
	_bus.wave_cleared.emit(boss_night)
	await process_frame
	_expect(_state.phase == Phase.DAWN, "wave_cleared(%d) pasa al Amanecer" % boss_night)
	_expect(_state.water == level.max_water, "Amanecer: agua llena")
	_expect(_last_water_event == [level.max_water, level.max_water], "Amanecer: water_changed")

	# --- Tras el último Amanecer, el ciclo se detiene ---
	var count: int = _phase_log.size()
	await create_timer(level.dawn_duration + 60.0).timeout
	_expect(_phase_log.size() == count, "tras el último Amanecer no hay más fases")
	_expect(_state.day == level.days and _state.phase == Phase.DAWN, "queda en el Amanecer del día 5")
	_press_f2()
	await process_frame
	_expect(_phase_log.size() == count, "F2 no hace nada con el ciclo detenido")

	if _failures == 0:
		print("day_cycle_check OK")
		quit(0)
	else:
		printerr("day_cycle_check: %d caso(s) fallaron" % _failures)
		quit(1)


func _on_phase_changed(phase: int) -> void:
	_phase_log.append([phase, _state.day, _elapsed])
	if phase == Phase.DAWN:
		_expect(_state.water == _state.max_water, "en phase_changed(Amanecer) el agua ya está llena")


func _wait_phase(phase: int, day: int, timeout: float) -> bool:
	var start: float = _elapsed
	while not (_state.phase == phase and _state.day == day and _phase_log.size() > 0
			and _phase_log.back()[0] == phase):
		if _elapsed - start > timeout:
			return false
		await process_frame
	return true


func _press_f2() -> void:
	var event := InputEventKey.new()
	event.physical_keycode = KEY_F2
	event.pressed = true
	root.push_input(event)
	var release := InputEventKey.new()
	release.physical_keycode = KEY_F2
	root.push_input(release)


func _phase_sequence_ok() -> bool:
	for i: int in range(1, _phase_log.size()):
		var prev: Array = _phase_log[i - 1]
		var cur: Array = _phase_log[i]
		var next_ok: bool = cur[0] == (prev[0] + 1) % 5
		var reload_ok: bool = cur[0] == Phase.MORNING and prev[0] == Phase.NIGHT # Muerte.
		if not (next_ok or reload_ok):
			return false
	return true


func _expect(condition: bool, label: String) -> void:
	if not condition:
		_failures += 1
		printerr("FALLA: ", label)
