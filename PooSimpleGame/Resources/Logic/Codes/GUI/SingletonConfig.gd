extends Node

enum ACTIONS {left, right, jump,dash}
var Input_dic : Dictionary
var sounds_dic :Dictionary
var graphics_dic: Dictionary
var json :Dictionary
var player_health : int
var player_sickness : int
var max_player_health : int
var max_player_sickness : int
var ammo:int
var reload_scene

func update_player_health(health,sickness,max_health,max_sickness):
	player_health=health
	player_sickness=sickness
	max_player_health=max_health
	max_player_sickness=max_sickness
	update_hud()

func update_hud():
	get_tree().root.get_node("World").update_hud()
