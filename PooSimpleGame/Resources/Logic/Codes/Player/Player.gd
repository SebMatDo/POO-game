extends KinematicBody2D

## INICIALIZAR VARIABLES BASICAS DE MOVIMIENTO##
var gravity = 120
var speed = 800
var jumpHeigth =1800
var jumpMax = 2
var jumpActual = 0
var velocity = Vector2() 
const COYOTE_DURATION=0.15
const dashDistance=0.2
var dashCD=1.5
var dashSpeed=2200
var dashMax=2
var dashActual=dashMax
#### INICIALIZAR BOOLEANOS DE ESTADOS ###
var isShooting = false

### VARIABLES AUXILIARES ###
var isFloor=false
var isDashing=false
var canDash=true
var canMove=true
onready var parent=get_parent()
### SEÑALES AUXILIARES
signal groundedUpdated(isFloor)


func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	parent.update_dash(dashActual)


func _process(delta):
	### SE OBTIENE EL O LOS BOTONES DEL JUGADOR
	get_input()
	
	### SE MUEVE DE FORMA SIN FRICCIÓN EN LA DIRECCION DE EL BOTON DEL JUGADOR
	
	#### SE AÑADE LA GRAVEDAD CONSTANTEMENTE
	velocity.y+=gravity 
	
	if isDashing:
		velocity.x=dashSpeed*$Sprite.scale.x
		velocity.y=0
	### SALTO, este se pone acá para confirmar si está en el piso
	###  SI ESTÁ EN EL PISO, OBTENDRÁ TODOS LOS SALTOS MAXIMOS
	if is_on_floor():
		jumpActual=0
		isFloor=true
		emit_signal("groundedUpdated",isFloor)
	### SI NO ESTÁ EN EL PISO, PONDRÁ UN TIEMPO DE COYOTE JUMP, PERO SOLO UNA VEZ GRACIAS A LA VARIABLE AUXILIAR
	else:
		emit_signal("groundedUpdated",isFloor)
		if isFloor==true:
			$tmr_CoyoteJump.start(COYOTE_DURATION)
		isFloor=false
	velocity = move_and_slide(velocity,Vector2.UP)
	


func get_input():
	if (Input.is_action_pressed("right")):
		velocity.x=speed
		$Sprite.scale.x=1
	if (Input.is_action_pressed("left")):
		velocity.x=-speed
		$Sprite.scale.x=-1
	if   (not Input.is_action_pressed("right") and  not Input.is_action_pressed("left")):
		velocity.x=0
	if (Input.is_action_just_pressed("jump")):
		if jumpActual<jumpMax:
			velocity.y = -jumpHeigth
			jumpActual+=1
	if (Input.is_action_just_pressed("dash")):
		if isDashing==false and canDash==true:
			isDashing=true
			canMove=false
			dashActual-=1
			$tmr_Dash.start(dashDistance)
			$tmr_DashCD.start(dashCD)
			
			parent.update_dash(dashActual)
			parent.load_dash(dashCD)
			if dashActual<=0:
				canDash=false


func _on_tmr_CoyoteJump_timeout():
	#### ESTE ES EL TIMER DEL COYOTE JUMP, CUANDO SE ACABA, SE TOMA COMO REALIZADO UN SALTO
	if jumpActual==0:
		jumpActual+=1


func _on_tmr_Dash_timeout():
	isDashing=false
	canMove=true


func _on_tmr_DashCD_timeout():
	if dashActual<dashMax:
		dashActual+=1
		canDash=true
		parent.update_dash(dashActual)
