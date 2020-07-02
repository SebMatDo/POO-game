extends Control

func _on_Timer_timeout():
	get_tree().change_scene(SingletonConfig.reload_scene)
