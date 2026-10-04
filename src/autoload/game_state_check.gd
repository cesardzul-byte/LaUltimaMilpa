## Verificación de snapshot()/restore(). No es autoload. Ejecutar con:
## godot --headless --path . --script res://src/autoload/game_state_check.gd
extends SceneTree


func _init() -> void:
	# Se instancia el script directo: en --script los autoloads no existen como globales.
	var state: Node = load("res://src/autoload/game_state.gd").new()
	state.water = 70
	state.cacao = 30
	state.inventory[&"maize"] = 6
	state.snapshot()

	state.water = 0
	state.cacao = 99
	state.inventory[&"maize"] = 50
	state.inventory[&"beans"] = 1
	state.restore()

	assert(state.water == 70, "restore(): agua")
	assert(state.cacao == 30, "restore(): cacao")
	assert(state.inventory == {&"maize": 6}, "restore(): inventario")

	state.free()
	print("game_state_check OK")
	quit()
