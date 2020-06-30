extends "res://Resources/Logic/Codes/Enemigos/BasicEnemy.gd"
var movable=true
var gravity=1
var look_at=Vector2(0,0)
var canThrow=true
var player 
var state=2
var SPEED=20
var JUMP = 0.02
var rand=0
var unreach=0.0
## state 0 es quieto,1 es lanzandose,2 moviendose al azar

func _ready():
	dmg=10
	health=10


func _physics_process(_delta):
	if disable==false:
		if movable==true:
			rotation=dir.angle()
			dir.y+=gravity
			
			if canThrow==true:
				if state==1:
					$tmr_move.start(1)
					$tmr_moveCD.start(2)
				elif state==2:
					$tmr_move.start(0.5)
					$tmr_moveCD.start(1.25)
				canThrow=false
			
			
			
		
func hurt_animation():
	$AnimationPlayer.play("hurt")

func death_animation():
	$AnimationPlayer.play("death")


func _on_tmr_move_timeout():
	var aux_angle
	if state==1:
		look_at=player.position
		aux_angle=(look_at-position).angle()
		var distance_to_xplayer=abs(look_at.x-position.x)
		if distance_to_xplayer>650:
			distance_to_xplayer=650
		var distance_to_yplayer=abs(look_at.y-position.y)
		if distance_to_yplayer>800:
			distance_to_yplayer=800
		dir=Vector2(cos(aux_angle+rand),sin(aux_angle+rand))*SPEED
		dir.y=- ( (JUMP+rand_range(0,0.01)) * distance_to_xplayer + JUMP*3 * distance_to_yplayer )
		unreach+=1.0
		if unreach>4:
			unreach=4.0
		rand=rand_range(0,unreach/10)
	
	elif state==2:
		aux_angle=-rand_range(0,PI)
	
		dir=Vector2(cos(aux_angle+rand),sin(aux_angle+rand))*SPEED
		dir.y=-17

	
	elif state==0:
		aux_angle=0
		dir=Vector2(cos(aux_angle+rand),sin(aux_angle+rand))*SPEED
		
	
	
	


func _on_Area_detect_body_entered(body):
	if movable==true:
		if body.is_in_group("player"):
			state=1
			player=body


func _on_tmr_moveCD_timeout():
	canThrow=true


func _on_Area_detect_body_exited(body):
	if body.is_in_group("player"):
		state=2
		
func hit(pj):
	if pj.canHurt==true:
		pj.health-=dmg
		pj.hurt(position)
	unreach=0.0
