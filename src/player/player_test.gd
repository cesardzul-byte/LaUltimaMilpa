extends Node2D
## Escena de prueba de ISS-09.
## Herramientas: checks automáticos de cycle_tool(); en headless sale con código 0 (todo PASS) o 1 (algún FAIL).
## Interacción: prueba manual; cambiar de herramienta con Q y pulsar E dentro y fuera de TestInteractable.

var _emitted: Array[StringName] = []
var _failed: bool = false

@onready var _player: CharacterBody2D = $Player
@onready var _interactable: InteractableComponent = $TestInteractable/InteractableComponent


func _enter_tree() -> void:
	get_tree().debug_collisions_hint = true  # sin arte: dibuja las formas para la prueba manual


func _ready() -> void:
	_player.tool_changed.connect(_on_tool_changed)
	_interactable.interacted.connect(_on_interacted)
	# add_item() llega con ISS-10: el inventario se asigna directamente.
	_run_case("A", {&"maize_seed": 1, &"beans_seed": 1, &"squash_seed": 1},
			[&"water_jar", &"maize_seed", &"beans_seed", &"squash_seed", &"copal_torch", &"spear"])
	_run_case("B", {&"maize_seed": 1, &"beans_seed": 0, &"squash_seed": 1},
			[&"water_jar", &"maize_seed", &"squash_seed", &"copal_torch", &"spear"])
	if DisplayServer.get_name() == "headless":
		get_tree().quit(1 if _failed else 0)


# Llama cycle_tool() una vez por id esperado; cada llamada debe emitir tool_changed exactamente una vez.
func _run_case(label: String, inventory: Dictionary[StringName, int], expected: Array[StringName]) -> void:
	GameState.inventory = inventory
	_player.active_tool = &"spear"
	_emitted.clear()
	for _i: int in expected.size():
		_player.cycle_tool()
	var ok: bool = _emitted == expected
	print("%s: caso %s, emitido %s" % ["PASS" if ok else "FAIL", label, _emitted])
	if not ok:
		_failed = true


func _on_tool_changed(tool_id: StringName) -> void:
	_emitted.append(tool_id)
	print("tool_changed(%s)" % tool_id)


func _on_interacted(actor: Node2D) -> void:
	print(actor.active_tool)
