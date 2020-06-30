extends KinematicBody2D

var dir=Vector2(0,0)
var coll=null
var minitree=preload("res://Resources/Logic/Scenes/Deco/miniTree.tscn")
var gravity=0
var tree_scale
var dmg

func _physics_process(_delta):
	dir.y+=gravity
	coll=move_and_collide(dir,true,true,false)

	if coll!=null:
		if (coll.collider.is_in_group("wall")):
			get_tree().root.get_node("World").add_child(create_tree())
			queue_free()
		elif coll.collider.is_in_group("enemy"):
			var aux=create_tree()
			aux.position=coll.position-coll.collider.position
			coll.collider.add_child(aux)
			coll.collider.hurt(dmg)
			queue_free()

func create_tree():
	var aux = minitree.instance()
	aux.position=coll.position
	var aux_rotation= (coll.position-position).angle()
	aux.rotation=aux_rotation
	aux.scale=Vector2(tree_scale,tree_scale)
	return aux
