class_name HealthComponent
extends Node
## Vida de una entidad. `damaged` emite el daño realmente aplicado; `died` se emite una sola vez.

signal damaged(amount: int)
signal died

@export_range(1, 9999) var max_health: int = 3

var current_health: int
var is_dead: bool = false


func _ready() -> void:
	current_health = max_health


func apply_damage(amount: int) -> void:
	if amount <= 0 or is_dead:
		return
	var applied: int = mini(amount, current_health)
	current_health -= applied
	# is_dead se fija antes de emitir: si un receptor de `damaged` vuelve a llamar aquí,
	# no se duplica `died`.
	var lethal: bool = current_health == 0
	if lethal:
		is_dead = true
	damaged.emit(applied)
	if lethal:
		died.emit()
