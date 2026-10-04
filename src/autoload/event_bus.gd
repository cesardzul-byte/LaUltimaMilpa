## Señales globales entre sistemas. Quien emite y quien escucha no se conocen.
## Solo declara señales; no tiene lógica.
extends Node

@warning_ignore_start("unused_signal")
signal phase_changed(phase: int) ## Valor de GameState.Phase.
signal day_started(day: int)
signal wave_started(night: int)
signal wave_cleared(night: int)
signal crop_planted(crop_id: StringName, cell: Vector2i)
signal crop_harvested(crop_id: StringName, amount: int)
signal water_changed(current: int, maximum: int)
signal cacao_changed(amount: int)
signal inventory_changed(item_id: StringName, amount: int)
signal creature_killed(creature_id: StringName)
signal animal_died(animal_id: StringName)
signal offering_delivered(item_id: StringName, amount: int)
signal codex_unlocked(entry_id: StringName)
signal ritual_finished(score: float) ## Se compara con RhythmChartData.pass_score.
signal player_died()
@warning_ignore_restore("unused_signal")
