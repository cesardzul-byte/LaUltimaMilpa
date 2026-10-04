## Entrada del códice. Campos según las columnas de docs/culture/glosario.md.
class_name CodexEntryData
extends Resource

@export var id: StringName
@export var term: String ## Grafía en maya yucateco.
@export var pronunciation: String
@export_multiline var meaning: String
@export_multiline var in_game_use: String
@export var sources: PackedStringArray = []
