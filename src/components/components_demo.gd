extends Node2D
## Escena de prueba de ISS-06.
## Daño: checks automáticos; en headless sale con código 0 (todo PASS) o 1 (algún FAIL).
## Interacción: prueba manual; mover Actor con las flechas y pulsar E dentro y fuera de Lever.

const ACTOR_SPEED: float = 100.0
const CHECK_DELAY: float = 2.5

var _hits: int = 0
var _deaths: int = 0
var _friendly_hits: int = 0
var _failed: bool = false

@onready var _dummy_health: HealthComponent = $Dummy/HealthComponent
@onready var _friendly_health: HealthComponent = $FriendlyDummy/HealthComponent
@onready var _hazard: HitboxComponent = $Hazard
@onready var _actor: CharacterBody2D = $Actor
@onready var _interactable: InteractableComponent = $Lever/InteractableComponent


func _enter_tree() -> void:
	get_tree().debug_collisions_hint = true  # sin arte: dibuja las formas para la prueba manual


func _ready() -> void:
	_dummy_health.damaged.connect(_on_dummy_damaged)
	_dummy_health.died.connect(_on_dummy_died)
	_friendly_health.damaged.connect(_on_friendly_damaged)
	_friendly_health.died.connect(_on_friendly_died)
	_interactable.interacted.connect(_on_interacted)
	_interactable.actor_entered.connect(_on_actor_entered)
	_interactable.actor_exited.connect(_on_actor_exited)
	get_tree().create_timer(CHECK_DELAY).timeout.connect(_run_final_checks)


func _physics_process(_delta: float) -> void:
	_actor.velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * ACTOR_SPEED
	_actor.move_and_slide()


# Solo llega aquí si el interactuable no consumió el evento.
func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	if _interactable.overlaps_body(_actor):
		_check(false, "interact con el actor dentro no emitió interacted")
	else:
		print("PASS: interact fuera del área no emitió")


func _on_dummy_damaged(amount: int) -> void:
	_hits += 1
	var expected: int = _dummy_health.max_health - _hits * _hazard.damage
	print("[t=%.2f s] Dummy damaged(%d)" % [_now(), amount])
	_check(_dummy_health.current_health == expected,
			"golpe %d: vida %d == %d" % [_hits, _dummy_health.current_health, expected])


func _on_dummy_died() -> void:
	_deaths += 1
	print("[t=%.2f s] Dummy died" % _now())


func _on_friendly_damaged(amount: int) -> void:
	_friendly_hits += 1
	print("[t=%.2f s] FriendlyDummy damaged(%d)" % [_now(), amount])


func _on_friendly_died() -> void:
	print("[t=%.2f s] FriendlyDummy died" % _now())


func _on_interacted(actor: Node2D) -> void:
	print("interacted(%s)" % actor.name)
	_check(_interactable.overlaps_body(actor), "interacted con el actor dentro del área")


func _on_actor_entered(actor: Node2D) -> void:
	print("actor_entered(%s): %s" % [actor.name, _interactable.prompt_text])


func _on_actor_exited(actor: Node2D) -> void:
	print("actor_exited(%s)" % actor.name)


func _run_final_checks() -> void:
	_check(_deaths == 1, "died emitido exactamente 1 vez (%d)" % _deaths)
	_check(_dummy_health.current_health == 0, "vida del Dummy en 0 (%d)" % _dummy_health.current_health)
	_check(_friendly_health.current_health == _friendly_health.max_health and _friendly_hits == 0,
			"FriendlyDummy intacto y sin damaged (%d golpes)" % _friendly_hits)
	if DisplayServer.get_name() == "headless":
		get_tree().quit(1 if _failed else 0)


func _check(ok: bool, label: String) -> void:
	print("%s: %s" % ["PASS" if ok else "FAIL", label])
	if not ok:
		_failed = true


func _now() -> float:
	return Time.get_ticks_msec() / 1000.0
