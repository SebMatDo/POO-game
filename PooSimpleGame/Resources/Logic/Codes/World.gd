extends Node2D

onready var player=$Player
onready var GUI=$GUILayer/GUI

### SE ENCARGARÁ DE UNIR LOS DATOS DEL JUEGO A LA GUI
func update_dash(dashActual):
	GUI.update_dash(dashActual)

func load_dash(duration):
	GUI.load_dash(duration)
