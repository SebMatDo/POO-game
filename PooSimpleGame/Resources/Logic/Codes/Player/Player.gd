extends KinematicBody2D
##### EL JUGADOR SOLO POSEE MOVIMIENTO Y COLISIONES, LAS ACCIONES DE ATACAR SON EN SU ARMA RESPECTIVA


## INICIALIZAR VARIABLES BASICAS DE MOVIMIENTO##
var gravity = 120
var speed = 800
var jumpHeigth =1800
var jumpMax = 2
var jumpActual = 0
var velocity = Vector2() 
const COYOTE_DURATION=0.15
var dashDistance=0.2
var dashCD=1.5
var dashSpeed=2200
var dashMax=2
var dashActual=dashMax

### Variables de estadisticas del personaje
var health = 100
var max_health=100
var sickness = 0
var max_sickness=50
const meleeCD=0.55
var maxGrenade=1
var actualGrenade=maxGrenade
var grenadeCD=3
#### INICIALIZAR BOOLEANOS DE ESTADOS ###
var isShooting = false
var isMelee = false
var isFloor=false
var isDashing=false
var canDash=true
var canMove=true
var canGrenade=true
var canHurt=true

### VARIABLES AUXILIARES ###
onready var parent=get_parent()
onready var dust=load("res://Resources/Logic/Scenes/Particle_dust.tscn")
onready var gun=$Sprite/spr_torso/spr_weapon_holder/GunWeaponCarton
onready var rastrillo =$Sprite/spr_torso/spr_weapon_holder/RastrilloWeapon
onready var grenade=preload("res://Resources/Logic/Scenes/GrenadeWeapon.tscn")
onready var animatorWeapon=$AnimationAttacks
onready var animatorPlayer = $AnimationPlayerStates
### SEÑALES AUXILIARES
signal groundedUpdated(isFloor)


func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	parent.update_dash(dashActual)
	animatorWeapon.play("Shoot")
	SingletonConfig.update_player_health(health,sickness,max_health,max_sickness)
	
	
func _physics_process(_delta):
	### SE OBTIENE EL O LOS BOTONES DEL JUGADOR
	if canMove==true:
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
		if $tmr_OnFloorCD.time_left==0: ###  ESTE TIMER ESTÁ ACÁ SOLO PARA ARREGLAR UN BUG DE TRIPLE SALTO, ACTUA COMO VERIFICADOR DE QUE SE HA DEJADO EL SUELO Y DA UN TIEMPITO PARA REINICIAR LOS SALTOS
			jumpActual=0
			isFloor=true
			emit_signal("groundedUpdated",isFloor)
		
		
	### SI NO ESTÁ EN EL PISO, PONDRÁ UN TIEMPO DE COYOTE JUMP, PERO SOLO UNA VEZ GRACIAS A LA VARIABLE AUXILIAR
	else:
		
		if isFloor==true:
			$tmr_CoyoteJump.start(COYOTE_DURATION)
		isFloor=false
	emit_signal("groundedUpdated",isFloor)
	velocity = move_and_slide(velocity,Vector2.UP)
	#print(velocity)

func get_input():
	#### ESTA FUNCIÓN OBTIENE CONSTANTEMENTE LOS INPUT DEL JUGADOR, LAS PALABRAS SON VARIABLES UNIDAS A UNA LETRA O BOTÓN DE MANDO
	if (Input.is_action_pressed("right")):
		velocity.x=speed
		$Sprite.scale.x=1
	if (Input.is_action_pressed("left")):
		velocity.x=-speed
		$Sprite.scale.x=-1
	if   (not Input.is_action_pressed("right") and  not Input.is_action_pressed("left")):
		velocity.x=0
		
	if (Input.is_action_just_pressed("jump")):
		### VERIFICA SI PUEDE SALTAR
		if jumpActual<jumpMax:
			jumpActual+=1
			$tmr_OnFloorCD.start(0.15)
			parent.sound("res://Resources/FX/Jump.wav",rand_range(0.8,1.25),2.5)
			velocity.y = jumpHeigth*-1
			
	if (Input.is_action_just_pressed("dash")):
		## VERIFICA SI PUEDE HACER DASH
		if isDashing==false and canDash==true:
			isDashing=true
			## CARGA EL EFECTO DE POLVO
			var auxDust=dust.instance()
			auxDust.position=position
			auxDust.scale.x=$Sprite.scale.x
			parent.add_child(auxDust)
			## HACE EL DASH
			canMove=false
			dashActual-=1
			parent.HUD.dash_fx(dashDistance)
			$tmr_Dash.start(dashDistance)
			$tmr_DashCD.start(dashCD)
			## MANDA LA INFO AL HUD
			parent.update_dash(dashActual)
			parent.sound("res://Resources/FX/dash.wav",rand_range(0.9,1.05),0)
			if dashActual<=0:
				canDash=false

	if (Input.is_action_just_pressed("melee")):
		if isMelee==false:
			isMelee=true
			
			animatorWeapon.play("MeleeAtk")
			$tmr_MeleeCD.start(meleeCD)
			gun.visible=false
			
	
	if (Input.is_action_pressed("shoot_left")):
		
		if gun.canShoot==true:
			gun.rotation=deg2rad(0)
			gun.scale.x=-1*$Sprite.scale.x
			gun.scale.y=1
			animatorWeapon.play("Shoot")
			gun.shoot(180)
			
	if (Input.is_action_pressed("shoot_right")):
		
		if gun.canShoot==true:
			gun.rotation=deg2rad(0)
			gun.scale.x=$Sprite.scale.x
			gun.scale.y=1
			animatorWeapon.play("Shoot")
			gun.shoot(0)
			
	if (Input.is_action_pressed("shoot_up")):
		
		if gun.canShoot==true:
			gun.rotation=deg2rad(-90)
			gun.scale.y=1
			gun.scale.x=1
			animatorWeapon.play("Shoot")
			gun.shoot(-90)
			
	if (Input.is_action_pressed("shoot_down")):
		if gun.canShoot==true:
			gun.rotation=deg2rad(-90)
			gun.scale.y=-1
			gun.scale.x=-1
			animatorWeapon.play("Shoot")
			gun.shoot(-270)

	if (!Input.is_action_pressed("shoot_down") && !Input.is_action_pressed("shoot_left") && !Input.is_action_pressed("shoot_right") && !Input.is_action_pressed("shoot_up")):
		
		if  animatorWeapon.current_animation=="":
			if animatorWeapon.current_animation_position == animatorWeapon.current_animation_length:
				gun.scale.x=1
				gun.scale.y=1
				gun.rotation=0

	if (Input.is_action_just_pressed("grenade")):
		if canGrenade==true and actualGrenade>0:
			canGrenade=false
			var aux_grenade = grenade.instance()
			aux_grenade.position=self.global_position
			aux_grenade.linear_velocity=Vector2((1550*$Sprite.scale.x),-800)
			aux_grenade.dmg=5
			aux_grenade.cuantity=15
			get_tree().root.get_node("World").add_child(aux_grenade)
			$tmr_GrenadeCD.start(grenadeCD)
			parent.HUD.update_grenadeCD(grenadeCD)

func hurt(enemy_pos,enemy_dmg : float):

	canHurt=false
	animatorPlayer.play("Hurt")
	canMove=false
	var aux_dir=(enemy_pos.x-position.x)
	velocity.x=speed*(aux_dir/abs(aux_dir))*-1*1.25
	$tmr_canHurtCD.start(0.7)
	$tmr_Hurted.start(0.185)
	SingletonConfig.update_player_health(health,sickness,max_health,max_sickness)
	$Camera2D.add_trauma(enemy_dmg/100)
	if health<=0:
		death()
	
func _on_tmr_CoyoteJump_timeout():
	#### ESTE ES EL TIMER DEL COYOTE JUMP, CUANDO SE ACABA, SE TOMA COMO REALIZADO UN SALTO
	if jumpActual==0:
		jumpActual=1


func _on_tmr_Dash_timeout():
	###### ESTA FUNCIÓN HACE QUE SE ACABE EL ESTADO DE DASH
	isDashing=false
	canMove=true


func _on_tmr_DashCD_timeout():
	#### ESTA FUNCIÓN CARGA EL DASH SEGÚN UN TIEMPO DETERMINADO
	if dashActual<dashMax:
		dashActual+=1
		canDash=true
		parent.update_dash(dashActual)
		$tmr_DashCD.start(dashCD)





func _on_tmr_MeleeCD_timeout():
	isMelee=false
	gun.visible=true
	rastrillo.visible=false


func _on_tmr_GrenadeCD_timeout():
	canGrenade=true


func _on_tmr_canHurtCD_timeout():
	canHurt=true



func _on_tmr_Hurted_timeout():
	canMove=true

func death():
	canMove=false
	canHurt=false
	## hacer la animacion
	parent.change_scene("res://Resources/Logic/Scenes/Muerte.tscn")
