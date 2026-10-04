class_name HurtboxComponent
extends Area2D
## Área que recibe golpes de HitboxComponent y los aplica a su HealthComponent.
## Tras cada golpe queda invulnerable `invulnerability_time` segundos.

const HURTBOX_LAYER: int = 1 << (8 - 1)  # capa 8 "hurtbox" de project.godot

@export var health_component: HealthComponent
@export var team: HitboxComponent.Team = HitboxComponent.Team.NEUTRAL
@export_range(0.0, 5.0, 0.05) var invulnerability_time: float = 0.5

var is_invulnerable: bool = false

var _invulnerability_timer: Timer


# Defaults en _init(): las propiedades guardadas en la escena se aplican después y los sobrescriben.
func _init() -> void:
	monitoring = true
	collision_layer = HURTBOX_LAYER
	collision_mask = HitboxComponent.HITBOX_LAYER


func _ready() -> void:
	if health_component == null:
		push_warning("HurtboxComponent en %s no tiene health_component; no aplicará daño." % get_path())
	# Timer hijo (no SceneTree.create_timer): respeta la pausa y se puede reiniciar.
	_invulnerability_timer = Timer.new()
	_invulnerability_timer.one_shot = true
	_invulnerability_timer.timeout.connect(_on_invulnerability_timeout)
	add_child(_invulnerability_timer)
	area_entered.connect(_try_receive_hit)


func _try_receive_hit(area: Area2D) -> bool:
	var hitbox: HitboxComponent = area as HitboxComponent
	if hitbox == null or is_invulnerable or health_component == null or health_component.is_dead:
		return false
	if hitbox.team == team and team != HitboxComponent.Team.NEUTRAL:
		return false
	health_component.apply_damage(hitbox.damage)
	if invulnerability_time > 0.0:
		is_invulnerable = true
		_invulnerability_timer.start(invulnerability_time)
	return true


# Revisa las áreas aún solapadas; sin esto una hitbox persistente solo golpearía una vez.
func _on_invulnerability_timeout() -> void:
	is_invulnerable = false
	for area: Area2D in get_overlapping_areas():
		if _try_receive_hit(area):
			break
