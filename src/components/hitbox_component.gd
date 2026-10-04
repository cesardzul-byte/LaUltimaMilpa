class_name HitboxComponent
extends Area2D
## Área que hace daño. Solo es detectada por las hurtboxes; no escanea nada.

## Equipo de origen del golpe. Regla de fuego amigo: la hurtbox ignora el golpe si
## `hitbox.team == hurtbox.team` y el equipo no es NEUTRAL. NEUTRAL nunca se filtra:
## un peligro del entorno también daña objetos neutrales.
enum Team { NEUTRAL, PLAYER, ENEMY }

const HITBOX_LAYER: int = 1 << (7 - 1)  # capa 7 "hitbox" de project.godot

@export var damage: int = 1
@export var team: Team = Team.NEUTRAL


# Defaults en _init(): las propiedades guardadas en la escena se aplican después y los sobrescriben.
func _init() -> void:
	monitoring = false
	monitorable = true
	collision_layer = HITBOX_LAYER
	collision_mask = 0
