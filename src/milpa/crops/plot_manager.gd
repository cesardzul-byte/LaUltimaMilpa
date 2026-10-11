## Crea una parcela en cada marcador del grupo `plots` y le pasa su estado guardado en
## GameState.world[&"plots"]: un arreglo con un diccionario por parcela, en el orden de
## los marcadores en la escena. Si falta un estado, la parcela arranca vacía.
class_name PlotManager
extends Node

const PLOT_SCENE: PackedScene = preload("res://src/milpa/crops/plot.tscn")


func _ready() -> void:
	if not GameState.world.has(&"plots"):
		GameState.world[&"plots"] = []
	var saved: Array = GameState.world[&"plots"]
	var markers: Array[Node] = get_tree().get_nodes_in_group(&"plots")
	for i: int in markers.size():
		if i >= saved.size():
			saved.append(Plot.empty_state())
		var plot: Plot = PLOT_SCENE.instantiate()
		plot.state = saved[i]
		# Hijo del marcador: queda en su posición y en el orden de dibujo de la milpa.
		markers[i].add_child(plot)
