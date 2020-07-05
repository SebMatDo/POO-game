extends "res://Resources/Logic/Codes/Enemigos/BasicEnemy.gd"

var movable=true
var gravity=1
var look_at=Vector2(0,0)
var canThrow=true
var player 
var state=2
var SPEED=10.2
var JUMP = 0.02
var distance=Vector2(0,0)
var canAtk=true
onready var money=preload("res://Resources/Logic/Scenes/Enemigos/EmpresarioAtk1.tscn")
var atkSpeed=25
### STATE 0 ES QUIETO 1 ES SEGUIR AL JUGADOR 2 ES MOVERSE AL AZAR

func _ready():
	dmg=10
	health=35
	GRAVITY=1
	FRICTION=1

func _physics_process(delta):
	if disable==false:
		if state==2:
			### MOVERSE al azar
			pass
		elif state==1:
			distance.x=abs(player.position.x)-abs(position.x) 
			if canAtk==true:
				if distance.x>0:
					$Sprite.scale.x=1
				else:
					$Sprite.scale.x=-1
				$tmr_atk.start(1)
				
				$AnimationPlayer.play("Atk")
				$tmr_atkCD.start(2)
				
				canAtk=false
			### Moverse al player
			
			
			
			if distance.x > 500:
				dir.x=SPEED
				
			elif distance.x < -500:
				dir.x=-SPEED
				
			elif distance.x < 400 and distance.x >0:
				dir.x-=SPEED*30*delta
				if dir.x<-SPEED/2:
					dir.x=-SPEED
			elif distance.x > -400 and distance.x <0:
				dir.x+=SPEED*30*delta
				if dir.x>SPEED/2:
					dir.x=SPEED
			elif distance.x>400 and distance.x<500:
				dir.x=0
			elif distance.x<-400 and distance.x>-500:
				dir.x=0
			
	## RESTO DE ACCIONES

func hurt_animation():
	$AnimationPlayer2.play("Hurt")
	
func death_animation():
	$AnimationPlayer.play("death")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player=body
		state=1

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		state=2

func _on_tmr_atk_timeout():
	var aux=money.instance()
	var aux_angle=(player.position-position).angle()
	aux.position=position
	aux.dir=Vector2(cos(aux_angle),sin(aux_angle))*atkSpeed
	aux.dir.y-=rand_range(-2,6)
	aux.dir.x-=rand_range(-2,2)
	
	get_tree().root.get_node("World").call_deferred("add_child",aux)
	state=0


func _on_tmr_atkCD_timeout():
	canAtk=true
	state=1
