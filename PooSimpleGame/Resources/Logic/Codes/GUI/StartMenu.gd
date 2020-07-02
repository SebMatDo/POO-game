extends Control

### PARA CAMBIAR LAS TECLAS, REF:ttps://www.gotut.net/godot-key-bindings-tutorial/
var can_change_key = false
var action_string
enum ACTIONS {left, right, jump,dash,melee,grenade,shoot_left,shoot_right,shoot_down,shoot_up}
var Input_dic : Dictionary
var sounds_dic :Dictionary
var graphics_dic: Dictionary
var json :Dictionary
const CONST_VOLUME_BG="VOLUMEN MUSICA:"
const CONST_VOLUME_FX="VOLUMEN EFECTO:"
onready var Lb_fx=$Pop_config/CenterContainer/VBoxContainer/HBoxContainer/Lb_fx
onready var Lb_music=$Pop_config/CenterContainer/VBoxContainer/HBoxContainer2/Lb_music
onready var Lb_width =$Pop_graficos/VBoxContainer/HBoxContainer/VBoxContainer2/Text_edit_width
onready var Lb_heigth = $Pop_graficos/VBoxContainer/HBoxContainer/VBoxContainer2/Text_edith_height
onready var Lb_full =$Pop_graficos/VBoxContainer/HBoxContainer/VBoxContainer2/Check_full

func _ready():
	$Pop_menu1.visible=true
	var load_conf=load_config()


	if load_conf.has("ERROR"):
		##save_config por default
		default_config()
	else:
		charge_config(load_conf)
	_set_keys() 
	
	var i=1
	for j in ACTIONS:
		var auxButton=get_node("Pop_teclado/CenterContainer2/HBoxContainer/VBoxContainer2/Bt_t" + str(i))
		auxButton.connect("pressed",self,"_mark_button",[auxButton.action])
		
		i+=1
	Lb_music.text=CONST_VOLUME_BG + str ( 100 + int (sounds_dic["bg_volume"]) )
	Lb_fx.text=CONST_VOLUME_FX+ str ( 100 + int (sounds_dic["fx_volume"]) )
	
	var width=graphics_dic["width"]
	var height = graphics_dic["heigth"]
	var full = graphics_dic["full_screen"]
	Lb_width.text=width
	Lb_heigth.text=height
	Lb_full.pressed=full
	OS.set_window_size(Vector2(width,height))
	OS.window_fullscreen=full
	
func _mark_button(string):
	can_change_key = true
	action_string = string
	var i =1
	for j in ACTIONS:
		if j != string:
			var auxButton=get_node("Pop_teclado/CenterContainer2/HBoxContainer/VBoxContainer2/Bt_t" + str(i))
			auxButton.set_pressed(false)
		i+=1
	print("PRESSED ",string)

func _input(event):
	
	if event is InputEventKey: 
		if can_change_key:
			_change_key(event)
			can_change_key = false

func _change_key(new_key):
	#Delete key of pressed button
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	
	#Check if new key was assigned somewhere
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
			
	#Add new Key
	InputMap.action_add_event(action_string, new_key)
	
	_set_keys()

func _set_keys():
	var i=1
	for j in ACTIONS:
		get_node("Pop_teclado/CenterContainer2/HBoxContainer/VBoxContainer2/Bt_t" + str(i)).set_pressed(false)
		var auxButton=get_node("Pop_teclado/CenterContainer2/HBoxContainer/VBoxContainer2/Bt_t" + str(i))
		if !InputMap.get_action_list(j).empty():
			var key= InputMap.get_action_list(j)[0]
			var strkey=OS.get_scancode_string(key.get_scancode_with_modifiers() )
			auxButton.set_text(strkey)
			auxButton.action=j
			
		else:
			auxButton.set_text("No Button!")
		i+=1
		
func default_config():
	var default =[ord('A'),ord('D'),ord('W'),KEY_SHIFT,ord('E'),ord('Q'),KEY_LEFT,KEY_RIGHT,KEY_DOWN,KEY_UP,0,0,720,1280,false]
	
	update_config(default[0],default[1],default[2],default[3],default[4],default[5],default[6],default[7],default[8],default[9],default[10],default[11],default[12],default[13],default[14])
	
func save_config(content):
	var file = File.new()
	file.open("user://ForEarthConfig.dat", File.WRITE)
	file.store_string(content)
	file.close()

func load_config():
	var file = File.new()
	
	var ER = file.open("user://ForEarthConfig.dat", File.READ)
	## EN CASO DE NECESITAR LA RUTA : print(file.get_path_absolute())
	if ER == OK:
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse(content)
		
		return result.result
		
	else:
		file.close()
# warning-ignore:unassigned_variable
		var content : Dictionary
		content["ERROR"]=ER
		
		return content
	
	
func charge_config(content):
	Input_dic=content["inputs"]
	sounds_dic=content["sounds"]
	
	graphics_dic=content["graphics"]
	
	for j in ACTIONS:
		var new_key=Input_dic[j]
		if !InputMap.get_action_list(j).empty():
			InputMap.action_erase_event(j, InputMap.get_action_list(j)[0])
		#Add new Key
		var key_load=InputEventKey.new()
		key_load.scancode=new_key
		
		InputMap.action_add_event(j,  key_load)

	_set_keys()
	Lb_fx.text=CONST_VOLUME_BG+str(sounds_dic["bg_volume"])
	
func _on_Bt_jugar_pressed():

	SingletonConfig.Input_dic=Input_dic
	SingletonConfig.graphics_dic=graphics_dic
	SingletonConfig.sounds_dic=sounds_dic
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Resources/Logic/Scenes/World.tscn")

func _on_Bt_opciones_button_down():

	$Pop_menu1.visible=false
	$Pop_config.visible=true


func _on_Bt_salir_pressed():
	
	get_tree().quit()


func _on_Bt_c1_pressed():
	$Pop_menu1.visible=false
	$Pop_config.visible=false
	$Pop_teclado.visible=true


func _on_Bt_t7_pressed():
	$Pop_menu1.visible=false
	$Pop_config.visible=true
	$Pop_teclado.visible=false


func _on_Bt_t_pressed():
	$Pop_teclado/CenterContainer2/HBoxContainer/VBoxContainer2/Bt_t.text=" "
	


func _on_Bt_t8_pressed():
# warning-ignore:unassigned_variable
	var config : Array
	for j in ACTIONS:
		var strkey
		if !InputMap.get_action_list(j).empty():
			var key= InputMap.get_action_list(j)[0]
			strkey=key.get_scancode_with_modifiers()
		else:
			strkey="no key"
		config.append(strkey)
		
	
	update_config(config[0],config[1],config[2],config[3],config[4],config[5],config[6],config[7],config[8],config[9],null,null,null,null,null)
	
	$Pop_menu1.visible=false
	$Pop_config.visible=true
	$Pop_teclado.visible=false

func update_config(left,right,jump,dash,melee,grenade,shoot_left,shoot_right,shoot_down,shoot_up,fx_volume,bg_volume,width,heigth,full):
	
	if left!=null:
		Input_dic["left"]=left
	if right!=null:
		Input_dic["right"]=right
	if jump!=null:
		Input_dic["jump"]=jump
	if dash!=null:
		Input_dic["dash"]=dash
	if melee!=null:
		Input_dic["melee"]=melee
	if grenade!=null:
		Input_dic["grenade"]=grenade
	if shoot_left!=null:
		Input_dic["shoot_left"]=shoot_left
	if shoot_right!=null:
		Input_dic["shoot_right"]=shoot_right
	if shoot_down!=null:
		Input_dic["shoot_down"]=shoot_down
	if shoot_up!=null:
		Input_dic["shoot_up"]=shoot_up
	
	
	if fx_volume!=null:
		sounds_dic["fx_volume"]=fx_volume
	if bg_volume!=null:
		sounds_dic["bg_volume"]=bg_volume
	if width!=null:
		graphics_dic["width"]  = width
	if heigth !=null:
		graphics_dic["heigth"] = heigth
	if full!=null:
		graphics_dic["full_screen"] = full
	
	json["inputs"]=Input_dic
	json["sounds"]=sounds_dic
	json["graphics"]=graphics_dic
	
	save_config(JSON.print(json))


func _on_Bt_c5_pressed():
	$Pop_menu1.visible=true
	$Pop_config.visible=false



func _on_Bt_c4_pressed():
	update_config(null,null,null,null,null,null,null,null,null,null,null,sounds_dic["bg_volume"]-5,null,null,null)
	Lb_music.text=CONST_VOLUME_BG + str ( 100 + int (sounds_dic["bg_volume"]) )


func _on_Bt_c6_pressed():
	update_config(null,null,null,null,null,null,null,null,null,null,null,sounds_dic["bg_volume"]+5,null,null,null)
	Lb_music.text=CONST_VOLUME_BG+ str ( 100 + int (sounds_dic["bg_volume"]) )


func _on_Bt_c2_pressed():
	update_config(null,null,null,null,null,null,null,null,null,null,sounds_dic["fx_volume"]-5,null,null,null,null)
	Lb_fx.text=CONST_VOLUME_FX+ str ( 100 + int (sounds_dic["fx_volume"]) )


func _on_Bt_c3_pressed():
	update_config(null,null,null,null,null,null,null,null,null,null,sounds_dic["fx_volume"]+5,null,null,null,null)
	Lb_fx.text=CONST_VOLUME_FX+ str ( 100 + int (sounds_dic["fx_volume"]) )


func _on_Bt_c8_pressed():
	$Pop_config.visible=false
	$Pop_graficos.visible=true


func _on_Bt_g1_pressed():
	$Pop_config.visible=true
	$Pop_graficos.visible=false
	var width = Lb_width.text
	var height = Lb_heigth.text
	var full = Lb_full.is_pressed()
	update_config(null,null,null,null,null,null,null,null,null,null,null,null,width,height,full)
	OS.set_window_size(Vector2(width,height))
	OS.window_fullscreen=full
	
func _on_Bt_g2_pressed():
	$Pop_config.visible=true
	$Pop_graficos.visible=false
