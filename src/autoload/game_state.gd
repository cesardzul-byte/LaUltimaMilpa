## Estado global de la partida. Datos y helpers que cambian un valor y emiten su señal;
## la lógica de cada sistema vive en su nodo.
extends Node

enum Phase { MORNING, AFTERNOON, DUSK, NIGHT, DAWN }

var level: LevelData ## Nivel en juego; lo asigna start_level().
var day: int = 1 ## 1 a level.days.
var phase: Phase = Phase.MORNING
var water: int = 0
var max_water: int = 0
var cacao: int = 0
var inventory: Dictionary[StringName, int] = {}
var offering_progress: Dictionary[StringName, int] = {} ## Entregado al templo, por ítem.
var unlocked_codex: Array[StringName] = []
var tutorial_active: bool = false
var day_stats: Dictionary[StringName, int] = {} ## Para el resumen del amanecer.
## Estado de la milpa que sobrevive a la recarga tras player_died (supuesto 24).
## Cada sistema usa su clave (&"plots", &"turkeys", &"walls"), escribe en cuanto cambia
## su estado y lo lee al cargarse; si la clave no existe, arranca con su estado inicial.
## Solo datos simples: snapshot() copia arreglos y diccionarios anidados, no nodos ni recursos.
var world: Dictionary[StringName, Variant] = {}

# Copia del amanecer, solo en memoria (GDD §10: sin guardado en disco).
var _saved: Dictionary = {}


## Empieza el nivel desde el día 1 con los valores iniciales de new_level.
func start_level(new_level: LevelData) -> void:
	level = new_level
	day = 1
	phase = Phase.MORNING
	max_water = level.max_water
	water = max_water
	cacao = level.starting_cacao
	inventory = level.starting_inventory.duplicate()
	offering_progress = {}
	day_stats = {}
	world = {}
	snapshot()


## Suma delta (puede ser negativo) al ítem. Devuelve false y no cambia nada
## si el total quedaría negativo.
func add_item(id: StringName, delta: int) -> bool:
	var total: int = inventory.get(id, 0) + delta
	if total < 0:
		return false
	inventory[id] = total
	EventBus.inventory_changed.emit(id, total)
	return true


## Suma delta (puede ser negativo) al cacao. Devuelve false y no cambia nada
## si el total quedaría negativo.
func add_cacao(delta: int) -> bool:
	var total: int = cacao + delta
	if total < 0:
		return false
	cacao = total
	EventBus.cacao_changed.emit(cacao)
	return true


## Gasta amount de agua. Devuelve false y no cambia nada si no alcanza.
func use_water(amount: int) -> bool:
	var total: int = water - amount
	if total < 0:
		return false
	water = total
	EventBus.water_changed.emit(water, max_water)
	return true


## Llena el agua a max_water (amanecer).
func refill_water() -> void:
	water = max_water
	EventBus.water_changed.emit(water, max_water)


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
		&"world": world.duplicate(true),
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
	# Copia profunda también al restaurar: así el snapshot sirve para varias muertes.
	world = _saved[&"world"].duplicate(true)
