## Se carga la plantilla por defecto
extends "res://Resources/Logic/Codes/Player/BasicGunWeapon.gd"

# INICIALIZAR VARIABLES UTILIZANDO LA PLANTILLA PERO PONIENDO VALORES


func _ready():
	
# INICIALIZAR VARIABLES
	bullet_point=$spr_bullet_location
	maxAmmo =10 
	ammo= 10
	reloadTime =1
	shootCD=1
	bullet=preload("res://Resources/Logic/Scenes/Bullet_player.tscn")
	amount=3
	lifetime=2
	bullet_vel=20
	tree_scale=0.25
	dmg=3
	
