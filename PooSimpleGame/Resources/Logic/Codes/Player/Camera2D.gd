extends Camera2D
## VARIABLES
onready var prev_camera_pos=get_camera_position()
const LOOK_AHEAD_FACTOR = 0.28
const SHIFT_TRANS= Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 0.2
var facing = 0
onready var tween= $Tween

### SCREEN SHAKE
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
#export (NodePath) var target  # Assign the node this camera will follow.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

# https://kidscancode.org/godot_recipes/2d/screen_shake/

func _on_Player_groundedUpdated(isFloor):
	### VERFIFICA SI EL JUGADOR ESTÁ EN EL AIRE, EN CASO DE SER CIERTO, SE DESHABILITA EL MARGEN VERTICAL
	drag_margin_v_enabled =!isFloor

func _process(delta):
	### CADA FRAME REVISA ESTO
	_check_facing()
	prev_camera_pos= get_camera_position()
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

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


func _ready():
	randomize()

func add_trauma(amount:float):
	trauma = min(trauma + amount+0.39, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)
