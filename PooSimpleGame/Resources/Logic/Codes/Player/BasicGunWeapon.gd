extends Node2D
### ESTA SERÁ LA PLANTILLA PADRE DE TODAS LAS ARMAS TIPO LANZA MAZORCAS

# INICIALIZAR VARIABLES
var maxAmmo :int 
var ammo: int
var reloadTime : float
var isShooting: bool
var canShoot=true
var shootCD : float
onready var bullet
var amount:int
var lifetime:int
var tmr_shootCD : Timer
var bullet_vel:int
var tree_scale=1
var dmg: int
onready var bullet_point
func _ready():
	tmr_shootCD=Timer.new()
	tmr_shootCD.process_mode=Timer.TIMER_PROCESS_PHYSICS
# warning-ignore:return_value_discarded
	tmr_shootCD.connect("timeout",self,"cdShootTimeOut")
	add_child(tmr_shootCD)
	
func shoot(direction):

	isShooting=true
	canShoot=false
	tmr_shootCD.start(shootCD)
	for i in range(amount):
		var aux_bullet=bullet.instance()
		aux_bullet.position=bullet_point.global_position
		#aux_bullet.position.y-=i*10
		var old_dir=direction+5
		var aux_dir = old_dir - (i*5)
		old_dir=deg2rad(aux_dir)
		aux_bullet.dir=Vector2(cos(old_dir),sin(old_dir))*bullet_vel
		aux_bullet.tree_scale=tree_scale
		aux_bullet.dmg=dmg
		get_tree().root.get_node("World").add_child(aux_bullet)
		
func cdShootTimeOut():
	isShooting=false
	canShoot=true
