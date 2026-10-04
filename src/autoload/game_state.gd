## Estado global de la partida. Solo datos; la lógica vive en cada sistema.
extends Node

enum Phase { MORNING, AFTERNOON, DUSK, NIGHT, DAWN }

var day: int = 1 ## 1 a 5.
var phase: Phase = Phase.MORNING
var water: int = 0
var max_water: int = 0
var cacao: int = 0
var inventory: Dictionary[StringName, int] = {}
var offering_progress: Dictionary[StringName, int] = {} ## Entregado al templo, por ítem.
var unlocked_codex: Array[StringName] = []
var tutorial_active: bool = false
var day_stats: Dictionary[StringName, int] = {} ## Para el resumen del amanecer.

# Copia del amanecer, solo en memoria (GDD §10: sin guardado en disco).
var _saved: Dictionary = {}


func snapshot() -> void:
	_saved = {
		&"day": day,
		&"phase": phase,
		&"water": water,
		&"max_water": max_water,
		&"cacao": cacao,
		&"inventory": inventory.duplicate(),
		&"offering_progress": offering_progress.duplicate(),
		&"unlocked_codex": unlocked_codex.duplicate(),
		&"tutorial_active": tutorial_active,
		&"day_stats": day_stats.duplicate(),
	}


func restore() -> void:
	if _saved.is_empty():
		push_warning("GameState.restore() sin snapshot() previo.")
		return
	day = _saved[&"day"]
	phase = _saved[&"phase"]
	water = _saved[&"water"]
	max_water = _saved[&"max_water"]
	cacao = _saved[&"cacao"]
	inventory = _saved[&"inventory"].duplicate()
	offering_progress = _saved[&"offering_progress"].duplicate()
	unlocked_codex = _saved[&"unlocked_codex"].duplicate()
	tutorial_active = _saved[&"tutorial_active"]
	day_stats = _saved[&"day_stats"].duplicate()
