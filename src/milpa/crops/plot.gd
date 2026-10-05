## Parcela de la milpa (GDD §3). Ya'ax siembra, riega y cosecha con E en la Mañana
## (supuesto 26); al amanecer crece si se regó o se seca tras wither_days sin agua.
## Su estado vive en un diccionario de GameState.world[&"plots"] que le pasa PlotManager.
class_name Plot
extends Node2D

const FRAMES: int = 4 ## Semilla, brote, planta, madura.

## Estado: crop (&"" = vacía), growth, dry_days, watered (hoy) y health.
## Es el mismo diccionario que está en GameState.world: modificarlo ya lo guarda.
var state: Dictionary = {}

var _crop: CropData

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _interactable: InteractableComponent = $InteractableComponent
@onready var _health: HealthComponent = $HealthComponent
@onready var _hurtbox: HurtboxComponent = $HurtboxComponent


## Estado de una parcela vacía.
static func empty_state() -> Dictionary:
	return {&"crop": &"", &"growth": 0, &"dry_days": 0, &"watered": false, &"health": 0}


func _ready() -> void:
	state.merge(empty_state()) # Completa claves faltantes sin pisar las guardadas.
	_interactable.interacted.connect(_on_interacted)
	_health.damaged.connect(_on_damaged)
	_health.died.connect(_clear)
	EventBus.phase_changed.connect(_on_phase_changed)
	_load_crop()


func _on_interacted(actor: Node2D) -> void:
	if GameState.phase != GameState.Phase.MORNING:
		return
	var tool: StringName = actor.get(&"active_tool")
	if _crop == null:
		_try_plant(tool)
	elif state[&"growth"] >= _crop.growth_days:
		_harvest()
	elif tool == &"water_jar":
		_try_water()


func _try_plant(tool: StringName) -> void:
	if not tool.ends_with("_seed"):
		return
	var crop_id: StringName = tool.trim_suffix("_seed")
	if not ResourceLoader.exists(_crop_path(crop_id)) or not GameState.add_item(tool, -1):
		return
	state.merge(empty_state(), true)
	state[&"crop"] = crop_id
	_load_crop()
	state[&"health"] = _crop.max_health
	_health.current_health = _crop.max_health
	EventBus.crop_planted.emit(crop_id, Vector2i(global_position))


func _try_water() -> void:
	if state[&"watered"] or not GameState.use_water(_crop.water_per_day):
		return
	state[&"watered"] = true
	_update_view()


func _harvest() -> void:
	var amount: int = randi_range(_crop.yield_min, _crop.yield_max)
	GameState.add_item(_crop.id, amount)
	EventBus.crop_harvested.emit(_crop.id, amount)
	_clear()


func _on_phase_changed(phase: int) -> void:
	if phase == GameState.Phase.DAWN and _crop != null:
		if state[&"watered"]:
			state[&"growth"] += 1
			state[&"dry_days"] = 0
		else:
			state[&"dry_days"] += 1
		state[&"watered"] = false
		if state[&"dry_days"] >= _crop.wither_days:
			_clear()
			return
	_update_view()


func _on_damaged(_amount: int) -> void:
	state[&"health"] = _health.current_health


## Deja la parcela vacía (cosecha, sequía o vida 0).
func _clear() -> void:
	state.merge(empty_state(), true)
	_load_crop()


## Lee state y ajusta cultivo, vida, grupo y colisiones.
func _load_crop() -> void:
	var crop_id: StringName = state[&"crop"]
	_crop = load(_crop_path(crop_id)) if crop_id != &"" else null
	var planted: bool = _crop != null
	if planted:
		_health.max_health = _crop.max_health
		_health.current_health = state[&"health"]
		_health.is_dead = false
		# ponytail: hoja por convención assets/sprites/crops/<id>.png; pasar a CropData si un cultivo no la sigue.
		_sprite.texture = load("res://assets/sprites/crops/%s.png" % crop_id)
		# Los cultivos altos crecen hacia arriba: la base del cuadro queda en el borde inferior del tile.
		_sprite.offset.y = 8.0 - _sprite.texture.get_height() / 2.0
		add_to_group(&"crops")
	elif is_in_group(&"crops"):
		remove_from_group(&"crops")
	# Diferido: puede venir de una señal de física (golpe), donde no se cambian áreas.
	_hurtbox.set_deferred(&"monitoring", planted)
	_hurtbox.set_deferred(&"monitorable", planted)
	_update_view()


func _update_view() -> void:
	_sprite.visible = _crop != null
	if _crop != null:
		_sprite.frame = mini(state[&"growth"] * (FRAMES - 1) / _crop.growth_days, FRAMES - 1)
	if GameState.phase != GameState.Phase.MORNING:
		_interactable.prompt_text = "" # E no hace nada fuera de la Mañana.
	elif _crop == null:
		_interactable.prompt_text = "Sembrar"
	elif state[&"growth"] >= _crop.growth_days:
		_interactable.prompt_text = "Cosechar"
	elif state[&"watered"]:
		_interactable.prompt_text = "Regada"
	else:
		_interactable.prompt_text = "Regar"


func _crop_path(crop_id: StringName) -> String:
	return "res://data/crops/%s.tres" % crop_id
