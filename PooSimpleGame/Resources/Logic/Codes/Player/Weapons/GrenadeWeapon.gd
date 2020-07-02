extends RigidBody2D
var explode_time=0.35
var fragments=preload("res://Resources/Logic/Scenes/Bullet_player.tscn")
var cuantity:int
const SPEED=10
var dmg:int
func _on_GrenadeWeapon_body_entered(body):
	if body.is_in_group("wall"):
		if $tmr_Explode.time_left==0:
			$tmr_Explode.start(explode_time)
	elif body.is_in_group("enemy"):
		if $tmr_Explode.time_left==0:
			$tmr_Explode.start(0.05)


func _on_tmr_Explode_timeout():
	for i in range(0,cuantity):
		#print("GHRANADA ; : ",i)
		var aux = fragments.instance()
		aux.position=global_position
		aux.gravity=1
		var aux_vec=deg2rad( (360/cuantity)*i )
		aux.dir=Vector2(cos(aux_vec),sin(aux_vec))*SPEED
		aux.scale.x=0.5
		aux.scale.y=0.5
		aux.tree_scale=0.5
		aux.dmg=dmg
		aux.scale=Vector2(0.75,0.75)
		get_tree().root.get_node("World").add_child(aux)
	
	queue_free()
