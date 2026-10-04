class_name InteractableComponent
extends Area2D
## Área que un actor (cuerpo en la capa "player") puede usar con la acción `interact`
## mientras está dentro. `actor_entered`/`actor_exited` indican a la UI cuándo mostrar `prompt_text`.

signal interacted(actor: Node2D)
signal actor_entered(actor: Node2D)
signal actor_exited(actor: Node2D)

const PLAYER_LAYER: int = 1 << (1 - 1)  # capa 1 "player" de project.godot
const INTERACTABLES_LAYER: int = 1 << (6 - 1)  # capa 6 "interactables" de project.godot

@export var prompt_text: String = "Interactuar"

# Lista y no booleano: si entran dos cuerpos y sale uno, el otro sigue dentro.
var _actors: Array[Node2D] = []


# Defaults en _init(): las propiedades guardadas en la escena se aplican después y los sobrescriben.
func _init() -> void:
	monitoring = true
	collision_layer = INTERACTABLES_LAYER
	collision_mask = PLAYER_LAYER


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# Se lee el evento, no el singleton Input: así se emite una vez por pulsación.
func _unhandled_input(event: InputEvent) -> void:
	if _actors.is_empty() or not event.is_action_pressed("interact"):
		return
	get_viewport().set_input_as_handled()  # dos interactuables solapados no se activan a la vez
	interacted.emit(_actors[0])


func _on_body_entered(body: Node2D) -> void:
	_actors.append(body)
	actor_entered.emit(body)


func _on_body_exited(body: Node2D) -> void:
	_actors.erase(body)
	actor_exited.emit(body)
