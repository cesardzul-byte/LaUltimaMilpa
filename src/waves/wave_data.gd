## Oleada de una noche (GDD §12).
class_name WaveData
extends Resource

@export var creatures: Dictionary[StringName, int] = {} ## id de criatura -> cantidad.
@export var spawn_interval: float = 8.0 ## s.
