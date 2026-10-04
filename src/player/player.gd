extends CharacterBody2D
## Ya'ax: se mueve en 8 direcciones a velocidad constante, anima según la dirección y tiene vida.
## Sus @export son la única fuente de verdad: se inyectan a los componentes en _ready().

@export var move_speed: float = 80.0
@export var max_health: int = 100
@export var invulnerability_time: float = 0.5

## Última dirección no nula; la usan la lanza y las antorchas.
var facing: Vector2 = Vector2.DOWN

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _health: HealthComponent = $HealthComponent
@onready var _hurtbox: HurtboxComponent = $HurtboxComponent


func _ready() -> void:
	# HealthComponent no tiene setter: su _ready() ya fijó current_health con el valor por defecto (3).
	_health.max_health = max_health
	_health.current_health = max_health
	_hurtbox.invulnerability_time = invulnerability_time
	_health.damaged.connect(_on_damaged)
	_health.died.connect(_on_died)


func _physics_process(_delta: float) -> void:
	# get_vector() ya limita la longitud a 1: en diagonal avanza los mismos px/s.
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		facing = direction
	velocity = direction * move_speed
	move_and_slide()
	_update_animation(direction)


func _update_animation(direction: Vector2) -> void:
	# hurt y die no se interrumpen; al terminar hurt, is_playing() es false y vuelve la animación normal.
	if _sprite.is_playing() and (_sprite.animation == &"hurt" or _sprite.animation == &"die"):
		return
	var anim: StringName
	if direction == Vector2.ZERO:
		anim = &"idle"
	elif absf(direction.x) >= absf(direction.y):
		anim = &"walk_side"
	elif direction.y > 0.0:
		anim = &"walk_down"
	else:
		anim = &"walk_up"
	# walk_side mira a la derecha en el sprite; se voltea solo hacia la izquierda.
	_sprite.flip_h = anim == &"walk_side" and direction.x < 0.0
	_sprite.play(anim)


func _on_damaged(_amount: int) -> void:
	if _health.is_dead:
		return  # el golpe letal lo maneja _on_died
	_sprite.play(&"hurt")


# HealthComponent emite `died` una sola vez.
func _on_died() -> void:
	velocity = Vector2.ZERO
	set_physics_process(false)
	_sprite.play(&"die")
	EventBus.player_died.emit()
