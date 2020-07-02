extends Node2D
var dmg = 5




func _on_Area2D_body_entered(body):
	if visible==true:
		if body.is_in_group("enemy"):
			if !body.is_in_group("metal"):
				body.hurt(dmg)
			else:
				body.hurt(dmg*3)
