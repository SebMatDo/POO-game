extends "res://Resources/Logic/Codes/Enemigos/BasicEnemy.gd"
var hited=0

func _ready():
	dmg=20
	
	$AnimationPlayer.play("Mocus")
	
func _physics_process(_delta):
	if coll!=null and coll.collider.is_in_group("wall"):
			queue_free()

func added_hit():
	hited+=1
	if hited==2:
		queue_free()
