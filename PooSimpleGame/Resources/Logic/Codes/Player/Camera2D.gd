extends Camera2D
## VARIABLES
onready var prev_camera_pos=get_camera_position()
const LOOK_AHEAD_FACTOR = 0.28
const SHIFT_TRANS= Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 0.2
var facing = 0
onready var tween= $Tween

func _on_Player_groundedUpdated(isFloor):
	### VERFIFICA SI EL JUGADOR ESTÁ EN EL AIRE, EN CASO DE SER CIERTO, SE DESHABILITA EL MARGEN VERTICAL
	drag_margin_v_enabled =!isFloor

func _process(delta):
	### CADA FRAME REVISA ESTO
	_check_facing()
	prev_camera_pos= get_camera_position()
	

func _check_facing():
	### VERIFICA SI EL PERSONAJE CAMBIA DE DIRECCION
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	### SI  CAMBIA DE DIRECCION
	if facing != new_facing:
		facing = new_facing
	### Y LA DIRECCION ES DIFERENTE DE CERO, ACTUALIZA LA POSICIÓN DE LA CAMARA PARA TENER MAS VISTA HACIA EL FRENTE
		if facing!=0:
			#### TOMA EL TAMAÑO DE LA CAMARA EN EL EJE X, LO MULTIPLICA POR LA DIRECCION A DONDE SE ESTÁ MIRANDO Y POR LA DISTANCIA CONSTANTE DE AHEADFACTOR
			var target_offset = get_viewport_rect().size.x * facing * LOOK_AHEAD_FACTOR
			#### ESTO SOLO SE ENCARGA DE SUAVIZAR EL CAMBIO DE LA POSICION X
			tween.interpolate_property(self,"position:x",position.x,target_offset,SHIFT_DURATION,SHIFT_TRANS,SHIFT_EASE)
			tween.start()
