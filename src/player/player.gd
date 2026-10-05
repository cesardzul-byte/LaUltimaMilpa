extends CharacterBody2D
## Ya'ax: se mueve en 8 direcciones a velocidad constante, anima según la dirección y tiene vida.
## Sus @export son la única fuente de verdad: se inyectan a los componentes en _ready().
## Cambia de herramienta con Q; E la usa el InteractableComponent, que consulta `active_tool`.

signal tool_changed(tool_id: StringName)

const TOOLS: Array[StringName] = [&"spear", &"water_jar", &"maize_seed", &"beans_seed", &"squash_seed", &"copal_torch"]

@export var move_speed: float = 80.0
@export var max_health: int = 100
@export var invulnerability_time: float = 0.5

## Última dirección no nula; la usan la lanza y las antorchas.
var facing: Vector2 = Vector2.DOWN
## Herramienta que leen los interactuables al recibir `interacted`.
var active_tool: StringName = TOOLS[0]

# Interactuables dentro del sensor, en orden de entrada.
var _interactables: Array[InteractableComponent] = []

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _health: HealthComponent = $HealthComponent
@onready var _hurtbox: HurtboxComponent = $HurtboxComponent
@onready var _sensor: Area2D = $InteractionSensor
@onready var _prompt: Label = $InteractionPrompt


func _ready() -> void:
	# HealthComponent no tiene setter: su _ready() ya fijó current_health con el valor por defecto (3).
	_health.max_health = max_health
	_health.current_health = max_health
	_hurtbox.invulnerability_time = invulnerability_time
	_health.damaged.connect(_on_damaged)
	_health.died.connect(_on_died)
	_sensor.area_entered.connect(_on_sensor_area_entered)
	_sensor.area_exited.connect(_on_sensor_area_exited)


func _process(_delta: float) -> void:
	# Se relee cada frame: ISS-17 cambia prompt_text según la parcela y no hay señal de cambio.
	# ponytail: con interactuables encimados el texto es del último que entró, pero E lo recibe
	# el que procese primero _unhandled_input; resolver si el diseño llega a encimarlos.
	_prompt.visible = not _interactables.is_empty()
	if _prompt.visible:
		_prompt.text = _interactables.back().prompt_text


# Se lee el evento, no el singleton Input: así cambia una vez por pulsación y sin eco.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cycle_tool"):
		cycle_tool()


func _physics_process(_delta: float) -> void:
	# get_vector() ya limita la longitud a 1: en diagonal avanza los mismos px/s.
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		facing = direction
	velocity = direction * move_speed
	move_and_slide()
	_update_animation(direction)


## Pasa a la siguiente herramienta de TOOLS, saltando las semillas sin unidades en el inventario.
func cycle_tool() -> void:
	var index: int = TOOLS.find(active_tool)
	# Siempre termina: spear, water_jar y copal_torch no son semillas.
	while true:
		index = (index + 1) % TOOLS.size()
		if not TOOLS[index].ends_with("_seed") or GameState.inventory.get(TOOLS[index], 0) > 0:
			break
	active_tool = TOOLS[index]
	tool_changed.emit(active_tool)


func _update_animation(direction: Vector2) -> void:
	# hurt, die y use_tool no se interrumpen; al terminar, is_playing() es false y vuelve la animación normal.
	if _sprite.is_playing() and _sprite.animation in [&"hurt", &"die", &"use_tool"]:
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


# E no se lee aquí: InteractableComponent ya consume el evento y leerlo de nuevo dependería del orden del árbol.
func _on_sensor_area_entered(area: Area2D) -> void:
	var interactable: InteractableComponent = area as InteractableComponent
	if interactable == null:
		return
	_interactables.append(interactable)
	interactable.interacted.connect(_on_interacted)


func _on_sensor_area_exited(area: Area2D) -> void:
	var interactable: InteractableComponent = area as InteractableComponent
	if interactable == null:
		return
	_interactables.erase(interactable)
	if interactable.interacted.is_connected(_on_interacted):
		interactable.interacted.disconnect(_on_interacted)


func _on_interacted(actor: Node2D) -> void:
	if actor == self and not _health.is_dead:
		_sprite.play(&"use_tool")


func _on_damaged(_amount: int) -> void:
	if _health.is_dead:
		return  # el golpe letal lo maneja _on_died
	_sprite.play(&"hurt")


# HealthComponent emite `died` una sola vez.
func _on_died() -> void:
	velocity = Vector2.ZERO
	set_physics_process(false)
	set_process_unhandled_input(false)
	_sprite.play(&"die")
	EventBus.player_died.emit()
