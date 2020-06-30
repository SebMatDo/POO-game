extends Node

enum ACTIONS {left, right, jump,dash}
var Input_dic : Dictionary
var sounds_dic :Dictionary
var graphics_dic: Dictionary
var json :Dictionary
var player_health : int
var player_sickness : int
var ammo:int


func update_player_health(health,sickness):
	player_health=health
	player_sickness=sickness
	update_hud()

func update_hud():
	get_tree().root.get_node("World").update_hud()
