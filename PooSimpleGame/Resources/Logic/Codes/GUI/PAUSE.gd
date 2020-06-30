extends Control

func _ready():
	$PAUSE_OFF.visible=true
	$PAUSE_ON.visible=false

func _process(_delta):
	###  AQUI SE PAUSA EL JUEGO Y TODO ESTO SE SIGUE EJECUTANDO
	
	if Input.is_action_just_pressed("ui_cancel"):
		if $Pop_text.visible==false:
			get_tree().paused=!get_tree().paused
			$PAUSE_ON.visible=get_tree().paused
			$PAUSE_OFF.visible=!get_tree().paused
		else:
			$Pop_text.visible=false
			get_tree().paused=false
	

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


func _on_Bt_salir_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Resources/Logic/Scenes/StartMenu.tscn")


func _on_Button_pressed():
	$Pop_text.visible=false
	get_tree().paused=false
	
func charge_text(keyword):
	get_tree().paused=true
	### LUEGO CARGAR UN JSON Y MOSTRAR TODO
