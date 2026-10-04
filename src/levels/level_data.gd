## Nivel (GDD §1, §9 y §12).
class_name LevelData
extends Resource

@export var id: StringName
@export_group("Fases (s)")
@export var morning_duration: float = 100.0
@export var afternoon_duration: float = 70.0
@export var dusk_duration: float = 30.0
@export var night_duration: float = 110.0
@export var dawn_duration: float = 20.0
@export_group("Partida")
@export var days: int = 5
@export var boss_night: int = 5
@export var waves: Array[WaveData] = [] ## waves[0] es la noche 1.
@export var max_water: int = 100
@export var starting_cacao: int = 30
@export var starting_inventory: Dictionary[StringName, int] = {}
@export var starting_turkeys: int = 2
@export_group("Reglas")
@export var exact_payment_discount: float = 0.10
@export var blessing_spawn_mult: float = 1.3
@export var mischief_plots: int = 2
@export var mischief_growth_loss: int = 1
@export var offering_requirements: Dictionary[StringName, int] = {} ## Incluye &"cacao".
