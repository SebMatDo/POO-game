extends Node2D

onready var player=$Player
onready var HUD=$GUILayer/HUD
onready var soundManager=$SoundManager
### SE ENCARGARÁ DE UNIR LOS DATOS DEL JUEGO A LA GUI

func update_dash(dashActual):
	#### ESTA FUNCION SE ENCARGA DE ACTUALIZAR EL NUMERO DE DASHES DISPONIBLES Y SI NO SE HA LLEGADO AL MAXIMO, SE HACE LA ANIMACIÓN DE CARGA EN LA GUI
	HUD.update_dash(dashActual)
	
	if dashActual<$Player.dashMax:
		HUD.load_dash($Player.dashCD)
	
func _ready():
	change_bg_music("res://Resources/Music/Alexander Ehlers - Spacetime.wav",1)
	Engine.target_fps=120
	
func sound(sound,pitch,added_vol):
	soundManager.create_sound(sound,pitch,added_vol)

func change_bg_music(music,pitch):
	soundManager.background_music(music,pitch)

func _physics_process(_delta):
	soundManager.update_pos(player.position)
func update_hud():
	HUD.update_hud()

