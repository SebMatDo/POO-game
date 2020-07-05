extends Control

func _ready():
	$PAUSE_OFF.visible=true
	$PAUSE_ON.visible=false

func _process(_delta):
	###  AQUI SE PAUSA EL JUEGO Y TODO ESTO SE SIGUE EJECUTANDO
	
	
	if $Pop_text.visible==false:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused=!get_tree().paused
			$PAUSE_ON.visible=get_tree().paused
			$PAUSE_OFF.visible=!get_tree().paused
	else:
		if Input.is_action_just_pressed("ui_cancel") or  Input.is_action_just_pressed("ui_accept") or  Input.is_action_just_pressed("melee"):
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
	get_tree().paused=false
	##  POR ALGUNA RAZÓN EL JUEGO PAUSADO Y VOLVER AL MENÚ NO SE DESPAUSA .-.
	get_tree().change_scene("res://Resources/Logic/Scenes/StartMenu.tscn")


func _on_Button_pressed():
	$Pop_text.visible=false
	get_tree().paused=false
	
func charge_text(keyword):
	get_tree().paused=true
	var file= File.new()
	
	var ER = file.open("allText.dat", File.READ)
	## EN CASO DE NECESITAR LA RUTA : 
	
	if ER == OK:
	
		var content = file.get_as_text()
		
		file.close()
		var result = JSON.parse(content)
		if result.error==OK:
			var parsed_content = result.result
			$Pop_text.visible=true
			if parsed_content.has(keyword):
				var keyword_in_parsed_content=parsed_content[keyword]
				$Pop_text/VBoxContainer/Lb_title.text=keyword_in_parsed_content[0]
				$Pop_text/VBoxContainer/HBoxContainer/Lb_description.text=keyword_in_parsed_content[1]
				$Pop_text/VBoxContainer/HBoxContainer/Lb_description.scroll_to_line(0)
				$Pop_text/VBoxContainer/HBoxContainer/Texture_Image_desc.texture=load("res://Resources/Visual/textImages/" + keyword_in_parsed_content[2])
			else:
				$Pop_text/VBoxContainer/Lb_title.text="ERROR ERROR ERROR"
				$Pop_text/VBoxContainer/HBoxContainer/Lb_description.text="Si ves esta descripción probablemente no se haya cargado correctamente la información, por lo tanto verifica que tienes el archivo all Text.dat, en caso extremo reinstala el juego, buena suerte y gracias por jugar, para reportar este bug deja un comentario"
				
		else: 
			print("HUBO UN ERROR CARGANDO EL JSON :C \t" + result.error_string +"\t"+ str(result.error_line))
	else:
		file.close()
		return "ERROR" + str(ER)
