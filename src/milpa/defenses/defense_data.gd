## Defensa (GDD §7 y §12).
class_name DefenseData
extends Resource

@export var id: StringName
@export var blocks: bool = false ## Bloquea el paso (capa walls).
@export var max_health: int = 60
@export var radius: float = 0.0 ## px.
@export var damage_per_second: float = 0.0
@export var cost: int = 0 ## Cacao.
@export var repair_amount: int = 0 ## HP. 0 = no se repara.
@export var repair_cost: int = 0 ## Cacao.
