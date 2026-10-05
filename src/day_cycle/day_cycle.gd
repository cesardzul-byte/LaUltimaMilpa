## Ciclo del día (GDD §1): Mañana → Tarde → Atardecer → Noche → Amanecer, con las
## duraciones de level. Arranca la partida, rellena el agua y guarda el snapshot del día,
## y repite el día cuando muere Ya'ax. Los demás sistemas solo escuchan EventBus.
class_name DayCycle
extends Node

@export var level: LevelData

var _timer: Timer
var _running: bool = false ## false antes de empezar, tras el último Amanecer o al morir Ya'ax.
var _reloading: bool = false


func _enter_tree() -> void:
	add_to_group(&"day_cycle")
	if level == null:
		push_error("DayCycle sin LevelData asignado.")
		return
	# Se arranca aquí y no en _ready para que GameState ya esté listo cuando corra el
	# _ready de cualquier sistema, sin importar el orden de los nodos en la escena.
	# Si GameState ya juega este nivel, es la recarga tras player_died: se usa lo restaurado.
	if GameState.level != level:
		GameState.start_level(level)


func _ready() -> void:
	_timer = Timer.new()
	_timer.name = &"PhaseTimer"
	_timer.one_shot = true
	_timer.timeout.connect(advance_phase)
	add_child(_timer)
	set_process_unhandled_input(OS.is_debug_build())
	if level == null:
		return
	EventBus.player_died.connect(_on_player_died)
	EventBus.wave_cleared.connect(_on_wave_cleared)
	_running = true
	# Diferido para que los sistemas de la escena ya estén conectados a EventBus
	# cuando se emitan phase_changed y day_started de la primera Mañana.
	_enter_phase.call_deferred(GameState.phase)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug_skip_phase"):
		get_viewport().set_input_as_handled()
		advance_phase()


## Segundos que faltan para que termine la fase. 0 si la fase no tiene límite
## (Noche del jefe) o si el ciclo está detenido.
func time_left() -> float:
	if _timer == null or _timer.is_stopped():
		return 0.0
	return _timer.time_left


## Duración total de la fase actual en segundos, para la barra del HUD.
## 0 si la fase no tiene límite (Noche del jefe).
func phase_duration() -> float:
	if _is_boss_night(GameState.phase):
		return 0.0
	return _duration(GameState.phase)


## Termina la fase actual y empieza la siguiente. Al terminar el Amanecer suma un día;
## tras el Amanecer del último día, el ciclo se detiene.
func advance_phase() -> void:
	if not _running:
		return
	match GameState.phase:
		GameState.Phase.MORNING:
			_enter_phase(GameState.Phase.AFTERNOON)
		GameState.Phase.AFTERNOON:
			_enter_phase(GameState.Phase.DUSK)
		GameState.Phase.DUSK:
			_enter_phase(GameState.Phase.NIGHT)
		GameState.Phase.NIGHT:
			_enter_phase(GameState.Phase.DAWN)
		GameState.Phase.DAWN:
			_end_dawn()


func _enter_phase(phase: GameState.Phase) -> void:
	if not _running:
		return
	# GameState y el temporizador se actualizan antes de emitir: quien escuche
	# phase_changed ya lee la fase, el agua y time_left() nuevos.
	GameState.phase = phase
	if phase == GameState.Phase.DAWN:
		GameState.refill_water()
	if _is_boss_night(phase):
		_timer.stop() # Termina con wave_cleared.
	else:
		_timer.start(_duration(phase))
	EventBus.phase_changed.emit(phase)
	if phase == GameState.Phase.MORNING:
		EventBus.day_started.emit(GameState.day)


func _end_dawn() -> void:
	if GameState.day >= level.days:
		# El ritual y el final son de la Fase 3.
		_running = false
		_timer.stop()
		return
	GameState.day += 1
	_enter_phase(GameState.Phase.MORNING)
	# Después de emitir: el snapshot ya incluye lo que los sistemas reinician al empezar el día.
	GameState.snapshot()


func _duration(phase: GameState.Phase) -> float:
	match phase:
		GameState.Phase.MORNING:
			return level.morning_duration
		GameState.Phase.AFTERNOON:
			return level.afternoon_duration
		GameState.Phase.DUSK:
			return level.dusk_duration
		GameState.Phase.NIGHT:
			return level.night_duration
		_:
			return level.dawn_duration


func _is_boss_night(phase: GameState.Phase) -> bool:
	return phase == GameState.Phase.NIGHT and GameState.day == level.boss_night


func _on_wave_cleared(night: int) -> void:
	if _running and _is_boss_night(GameState.phase) and night == GameState.day:
		advance_phase()


func _on_player_died() -> void:
	if _reloading:
		return
	_reloading = true
	_running = false
	_timer.stop()
	GameState.restore()
	get_tree().reload_current_scene()
