## Criatura enemiga (GDD §6 y §12).
class_name CreatureData
extends Resource

@export var id: StringName
@export var max_health: int = 50
@export var move_speed: float = 60.0 ## px/s.
@export var damage: int = 10
@export var attack_cooldown: float = 1.5 ## s.
@export var attack_range: float = 24.0 ## px.
@export var flies: bool = false ## Salta albarradas.
@export var cacao_drop_min: int = 0
@export var cacao_drop_max: int = 0
