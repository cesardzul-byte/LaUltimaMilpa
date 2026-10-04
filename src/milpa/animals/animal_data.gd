## Animal de la milpa (GDD §4 y §12).
class_name AnimalData
extends Resource

@export var id: StringName
@export var max_health: int = 30
@export var needs_food: bool = true
@export var feed_per_day: int = 1 ## Maíz.
@export var produce_item: StringName
@export var produce_interval: int = 2 ## Días.
@export var days_unfed_to_escape: int = 2
