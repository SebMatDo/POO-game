extends Control


func _process(_delta):
	###  AQUI SE PAUSA EL JUEGO Y TODO ESTO SE SIGUE EJECUTANDO
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused=!get_tree().paused
		$PAUSE_ON.visible=get_tree().paused
		$PAUSE_OFF.visible=!get_tree().paused


func _on_Bt_resume_pressed():
	get_tree().paused=!get_tree().paused
	$PAUSE_ON.visible=get_tree().paused
	$PAUSE_OFF.visible=!get_tree().paused


func _on_bt_bgSound_pressed():
	### AQUÍ IRIA UNA EDICION DE INIS CONFIG
	pass # Replace with function body.


func _on_bt_fxSound_pressed():
	### AQUÍ IRIA UNA EDICION DE INIS CONFIG
	pass # Replace with function body.


func _on_bt_pause_off_pressed():
	get_tree().paused=!get_tree().paused
	$PAUSE_ON.visible=get_tree().paused
	$PAUSE_OFF.visible=!get_tree().paused
