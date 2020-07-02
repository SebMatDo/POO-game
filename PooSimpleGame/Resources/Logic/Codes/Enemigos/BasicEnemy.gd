extends KinematicBody2D
var health : int
var dir =Vector2(0,0)
var dmg: int
var disable=false
var coll
var invencible = false
var collision_shape

func _ready():
	### ESTO LOS METE EN UN SOLO GRUPO Y EVITA QUE SE COLISIONEN ENTRE SÍ
	add_to_group("enemy")
	
	for i in get_tree().get_nodes_in_group("enemy"):
		add_collision_exception_with(i)
		

func _physics_process(_delta):
	if disable==false:
		coll = move_and_collide(dir,true,false,false)
		if coll!=null and coll.collider.is_in_group("player"):
			hit(coll.collider)

func hit(pj):
	if pj.canHurt==true:
		pj.health-=dmg
		pj.hurt(position,dmg)
		added_hit()

func hurt(pj_dmg):
	if invencible==false:
		health-=pj_dmg
		hurt_animation()
		if health<=0:
			death()
			death_animation()
	
func hurt_animation():
	#### este  se pone en el hijo qu elo hereda
	pass

func death():
	invencible=true
	collision_shape.disabled=true
	
	disable=true
	set_collision_mask_bit(0,false)
	set_collision_mask_bit(1,false)
	set_collision_layer_bit(1,false)
	
	
	
func death_animation():
	#### este  se pone en el hijo qu elo hereda
	pass

func added_hit():
	pass
