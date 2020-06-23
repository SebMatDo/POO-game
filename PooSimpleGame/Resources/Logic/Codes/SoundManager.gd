extends Node2D

## Variables
var volume = 0
onready var fx_bg=$AudioStreamPlayer
var fx=preload("res://Resources/Logic/Scenes/AudioStreamPlayer2D.tscn")
var bg_volume=0
func _ready():
	pass
func create_sound(sound,pitch,added_vol):
	var fx_snd=AudioStreamPlayer2D.new()
	add_child(fx_snd)
	fx_snd.volume_db=0+volume+added_vol
	fx_snd.pitch_scale=pitch
	var auxSound = load(sound)
	fx_snd.stream=auxSound
	fx_snd.play()
	

func background_music(music,pitch):
	fx_bg.volume_db=-8+bg_volume
	fx_bg.pitch_scale=pitch
	var auxMusic=load(music)
	fx_bg.stream=auxMusic
	fx_bg.play()
	yield(fx_bg,"finished")
	fx_bg.play(0)

func update_pos(pos):
	position=pos
