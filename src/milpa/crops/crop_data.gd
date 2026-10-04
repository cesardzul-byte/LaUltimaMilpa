## Cultivo de la milpa (GDD §3 y §12).
class_name CropData
extends Resource

@export var id: StringName
@export var growth_days: int = 3
@export var water_per_day: int = 10
@export var wither_days: int = 2 ## Días seguidos sin agua antes de secarse.
@export var yield_min: int = 3
@export var yield_max: int = 5
@export var max_health: int = 20
