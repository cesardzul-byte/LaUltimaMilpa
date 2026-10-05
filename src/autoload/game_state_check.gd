## Verificación de GameState. No es autoload. Ejecutar con:
## godot --headless --path . --script res://src/autoload/game_state_check.gd
## Termina con código 0 si todo pasa y con 1 si algo falla.
extends SceneTree

var _failures: int = 0
var _emitted: Array[Array] = [] ## Señales recibidas de EventBus: [nombre, args...].


func _initialize() -> void:
	# Los autoloads ya existen en _initialize (en _init todavía no), pero este script se
	# compila antes que ellos y no puede nombrarlos: se buscan en root. Cada caso usa
	# una instancia propia de game_state.gd; EventBus es el autoload real.
	var bus: Node = root.get_node(^"EventBus")
	bus.inventory_changed.connect(
		func(id: StringName, amount: int) -> void: _emitted.append([&"inventory_changed", id, amount])
	)
	bus.cacao_changed.connect(
		func(amount: int) -> void: _emitted.append([&"cacao_changed", amount])
	)
	bus.water_changed.connect(
		func(current: int, maximum: int) -> void: _emitted.append([&"water_changed", current, maximum])
	)

	_test_snapshot_restore()
	_test_add_item()
	_test_add_cacao()
	_test_use_water()
	_test_refill_water()
	_test_world()
	_test_start_level()

	if _failures == 0:
		print("game_state_check OK")
		quit(0)
	else:
		printerr("game_state_check: %d caso(s) fallaron" % _failures)
		quit(1)


func _test_snapshot_restore() -> void:
	var state: Node = _new_state()
	state.water = 70
	state.cacao = 30
	state.inventory[&"maize"] = 6
	state.snapshot()

	state.water = 0
	state.cacao = 99
	state.inventory[&"maize"] = 50
	state.inventory[&"beans"] = 1
	state.restore()

	_expect(state.water == 70, "restore(): agua")
	_expect(state.cacao == 30, "restore(): cacao")
	_expect(state.inventory == {&"maize": 6}, "restore(): inventario")
	state.free()


func _test_add_item() -> void:
	var state: Node = _new_state()
	state.inventory[&"maize"] = 6

	_expect(state.add_item(&"maize", -10) == false, "add_item(): devuelve false si quedaría negativo")
	_expect(state.inventory == {&"maize": 6}, "add_item(): no cambia el inventario si quedaría negativo")
	_expect_emitted([], "add_item(): no emite si quedaría negativo")

	_expect(state.add_item(&"maize", -2) == true, "add_item(): devuelve true al restar")
	_expect(state.inventory[&"maize"] == 4, "add_item(): resta")
	_expect_emitted([[&"inventory_changed", &"maize", 4]], "add_item(): emite el total nuevo al restar")

	_expect(state.add_item(&"maize", -4) == true, "add_item(): puede llegar a 0")
	_expect(state.inventory[&"maize"] == 0, "add_item(): queda en 0")
	_expect_emitted([[&"inventory_changed", &"maize", 0]], "add_item(): emite 0")

	_expect(state.add_item(&"beans", 3) == true, "add_item(): ítem nuevo")
	_expect(state.inventory[&"beans"] == 3, "add_item(): ítem nuevo empieza en 0")
	_expect_emitted([[&"inventory_changed", &"beans", 3]], "add_item(): emite el total del ítem nuevo")

	_expect(state.add_item(&"squash", -1) == false, "add_item(): ítem inexistente no baja de 0")
	_expect(not state.inventory.has(&"squash"), "add_item(): no crea el ítem si falla")
	_expect_emitted([], "add_item(): no emite con ítem inexistente")
	state.free()


func _test_add_cacao() -> void:
	var state: Node = _new_state()
	state.cacao = 30

	_expect(state.add_cacao(-31) == false, "add_cacao(): devuelve false si quedaría negativo")
	_expect(state.cacao == 30, "add_cacao(): no cambia si quedaría negativo")
	_expect_emitted([], "add_cacao(): no emite si quedaría negativo")

	_expect(state.add_cacao(-30) == true, "add_cacao(): puede llegar a 0")
	_expect(state.cacao == 0, "add_cacao(): resta")
	_expect_emitted([[&"cacao_changed", 0]], "add_cacao(): emite el total nuevo al restar")

	_expect(state.add_cacao(12) == true, "add_cacao(): suma")
	_expect(state.cacao == 12, "add_cacao(): total al sumar")
	_expect_emitted([[&"cacao_changed", 12]], "add_cacao(): emite el total nuevo al sumar")
	state.free()


func _test_use_water() -> void:
	var state: Node = _new_state()
	state.max_water = 100
	state.water = 15

	_expect(state.use_water(10) == true, "use_water(): devuelve true si alcanza")
	_expect(state.water == 5, "use_water(): resta")
	_expect_emitted([[&"water_changed", 5, 100]], "use_water(): emite el total y el máximo")

	_expect(state.use_water(10) == false, "use_water(): devuelve false si no alcanza")
	_expect(state.water == 5, "use_water(): no cambia si no alcanza")
	_expect_emitted([], "use_water(): no emite si no alcanza")

	_expect(state.use_water(5) == true, "use_water(): puede llegar a 0")
	_expect(state.water == 0, "use_water(): queda en 0")
	_expect_emitted([[&"water_changed", 0, 100]], "use_water(): emite 0")
	state.free()


func _test_refill_water() -> void:
	var state: Node = _new_state()
	state.max_water = 100
	state.water = 5
	state.refill_water()
	_expect(state.water == 100, "refill_water(): llena a max_water")
	_expect_emitted([[&"water_changed", 100, 100]], "refill_water(): emite water_changed")
	state.free()


func _test_world() -> void:
	var state: Node = _new_state()
	state.world[&"plots"] = [{&"crop": &"maize", &"growth": 1, &"cell": Vector2i(2, 3)}]
	state.world[&"turkeys"] = {&"count": 2, &"hunger": [0, 1]}
	state.snapshot()

	# Cambios anidados: si la copia no fuera profunda, también cambiarían el snapshot.
	state.world[&"plots"][0][&"growth"] = 3
	state.world[&"turkeys"][&"hunger"].append(2)
	state.world[&"walls"] = {&"north": 50}
	state.restore()

	var plots: Array = state.world[&"plots"]
	var turkeys: Dictionary = state.world[&"turkeys"]
	_expect(plots[0][&"growth"] == 1, "world: restore() devuelve el valor anidado del snapshot")
	_expect(plots[0][&"cell"] == Vector2i(2, 3), "world: conserva Vector2i")
	_expect(turkeys[&"hunger"] == [0, 1], "world: restore() devuelve el arreglo anidado del snapshot")
	_expect(not state.world.has(&"walls"), "world: restore() quita claves nuevas")

	# Un segundo restore() tras volver a cambiar world da el mismo snapshot (dos muertes seguidas).
	state.world[&"plots"][0][&"growth"] = 4
	state.restore()
	_expect(state.world[&"plots"][0][&"growth"] == 1, "world: el snapshot sirve para varios restore()")
	state.free()


func _test_start_level() -> void:
	var level: LevelData = load("res://data/levels/level_01.tres")
	var state: Node = _new_state()
	state.day = 4
	state.phase = 3 # Noche.
	state.water = 0
	state.cacao = 99
	state.inventory[&"copal"] = 9
	state.offering_progress[&"maize"] = 5
	state.world[&"plots"] = [{&"growth": 2}]
	state.start_level(level)

	_expect(state.level == level, "start_level(): guarda el nivel")
	_expect(state.day == 1, "start_level(): día 1")
	_expect(state.phase == 0, "start_level(): Mañana")
	_expect(state.max_water == level.max_water, "start_level(): max_water del nivel")
	_expect(state.water == level.max_water, "start_level(): agua llena")
	_expect(state.cacao == level.starting_cacao, "start_level(): cacao inicial")
	_expect(state.inventory == level.starting_inventory, "start_level(): inventario inicial")
	_expect(state.offering_progress.is_empty(), "start_level(): ofrenda vacía")
	_expect(state.world.is_empty(), "start_level(): world vacío")

	state.inventory[&"maize"] = 0
	_expect(level.starting_inventory[&"maize"] == 6, "start_level(): el inventario es una copia del recurso")

	# El primer snapshot() ya está hecho: restore() vuelve al inicio del día 1.
	state.day = 2
	state.water = 10
	state.world[&"plots"] = []
	state.restore()
	_expect(state.day == 1, "start_level(): snapshot del día 1")
	_expect(state.water == level.max_water, "start_level(): snapshot con agua llena")
	_expect(state.inventory == level.starting_inventory, "start_level(): snapshot con inventario inicial")
	_expect(state.world.is_empty(), "start_level(): snapshot con world vacío")
	state.free()


func _new_state() -> Node:
	_emitted.clear()
	return load("res://src/autoload/game_state.gd").new()


func _expect(condition: bool, label: String) -> void:
	if not condition:
		_failures += 1
		printerr("FALLA: ", label)


## Compara las señales recibidas desde la última comprobación y las limpia.
func _expect_emitted(expected: Array, label: String) -> void:
	_expect(_emitted == expected, "%s (recibido: %s)" % [label, _emitted])
	_emitted.clear()
