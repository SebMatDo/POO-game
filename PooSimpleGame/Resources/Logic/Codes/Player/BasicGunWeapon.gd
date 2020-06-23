extends Node2D
### ESTA SERÁ LA PLANTILLA PADRE DE TODAS LAS ARMAS TIPO LANZA MAZORCAS

# INICIALIZAR VARIABLES
var maxAmmo :int 
var ammo: int
var reloadTime : int
var isShooting: bool
var canShoot: bool
var shootCD:int
var dir : int

func _process(_delta):
	if (Input.is_action_just_pressed("shoot")):
		shoot()
func shoot():
	pass
