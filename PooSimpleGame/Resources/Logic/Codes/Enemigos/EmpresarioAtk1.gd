extends "res://Resources/Logic/Codes/Enemigos/BasicEnemy.gd"


func _ready():
	dmg=20
	GRAVITY=0.1
	FRICTION=14
	health=1
	
func _physics_process(_delta):
	if disable==false:
		if coll!=null:
			if  coll.collider!=null and coll.collider.is_in_group("wall"):
				death()
				death_animation()

func added_hit():
	death()
	death_animation()
	
func death_animation():
	GRAVITY=0.5
	
	$AnimationPlayer.play("death")
