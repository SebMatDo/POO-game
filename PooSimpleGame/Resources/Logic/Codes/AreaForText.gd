extends Area2D

export var keyword : String


func _on_AreaForText_body_entered(body):
	if body.is_in_group("player"):
		get_tree().root.get_node("World").PAUSE.charge_text(keyword)
		queue_free()
