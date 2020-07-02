extends "res://Resources/Logic/Codes/Enemigos/BasicEnemy.gd"
onready var rc=$R_Cast_detectPlayer
var atk1CD=1.5
var canAtk1=true
var atkSpeed=25
onready var mocusball= preload("res://Resources/Logic/Scenes/Enemigos/TrashCanAtk1/TrashCanAttack1.tscn")

func _ready():
	health=50
	dmg=2
	collision_shape=$CollisionShape2D

func _physics_process(_delta):
	dir.y+=3
	if disable==false:
		if rc.is_colliding():
			if rc.get_collider().is_in_group("player"):
			
			#print(rc.get_collision_point(),"\t",position,"\t",rc.get_collision_point().x-position.x)
				if (rc.get_collision_point().x-position.x)>0:
					$Sprite.scale.x=1
				elif (rc.get_collision_point().x-position.x)<0 :
					$Sprite.scale.x=-1
				
				if canAtk1==true:
					$tmr_atk1.start(1)
					$AnimationPlayer.play("atk1")
					$tmr_atk1CD.start(atk1CD)
					canAtk1=false

func attack1():
	var aux=mocusball.instance()
	aux.position=position
	aux.invencible=true
	aux.dir=Vector2(atkSpeed*$Sprite.scale.x,0)
	get_tree().root.get_node("World").call_deferred("add_child",aux)
	
func _on_tmr_atk1CD_timeout():
	canAtk1=true

func hurt_animation():
	$AnimationPlayer2.play("hurt")

func death_animation():
	$AnimationPlayer.play("death")

func _on_tmr_atk1_timeout():
	attack1()
