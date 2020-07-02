extends Control


####   VARIABLES AUXILIARES
var auxHeight=0
var auxHeightUpdate=0
var auxDuration=0
var auxGrenadeCD : float
#### CADA FRAME VERIFICAR LOS FPS /// SOLO PORDEBUG POR AHORA

func _process(_delta):

	$Lb_fps.text="fps: " + str(Engine.get_frames_per_second())

	
func update_hud():
	$Lb_ammo.text="ammo: "+ str(SingletonConfig.ammo)
	$HealthBar.value=SingletonConfig.player_health
	$HealthBar.rect_scale.x=0.5* SingletonConfig.max_player_health/100
	$SickBar.value= SingletonConfig.player_sickness
	$SickBar.rect_scale.x=0.5*SingletonConfig.max_player_sickness/100

func update_grenadeCD(CD):
	auxGrenadeCD=CD
	$tmr_updateGrenade.start(auxGrenadeCD/60)
	$spr_grenade.modulate=Color("635f5f")
	$spr_grenade.modulate.a=0.0
	

func update_dash(dash):
	#### ESTA FUNCIÓN DIBUJA EL NUMERO DE TRIANGULITOS(DASHES ) EN LA GUI
	if dash == 0:
		$spr_dash_load/spr_dash1.visible=false
		$spr_dash_load/spr_dash2.visible=false
		$spr_dash_load/spr_dash3.visible=false
	elif dash==1:
		
		$spr_dash_load/spr_dash1.visible=true
		$spr_dash_load/spr_dash2.visible=false
		$spr_dash_load/spr_dash3.visible=false
	elif dash==2:
		
		$spr_dash_load/spr_dash1.visible=true
		$spr_dash_load/spr_dash2.visible=true
		$spr_dash_load/spr_dash3.visible=false
	elif dash==3:
		
		$spr_dash_load/spr_dash1.visible=true
		$spr_dash_load/spr_dash2.visible=true
		$spr_dash_load/spr_dash3.visible=true
		
func load_dash(duration):
	#### ESTA FUNCIÓN HACE LA ANIMACIÓN DE CARGA DEL DASH SIGUIENTE
	auxDuration=duration/60
	auxHeight=0
	$spr_dash_load.region_rect=Rect2(0,0,301,0)
	$tmr_update.start(auxDuration)
func dash_fx(duration):
	$dash_fx.visible=true
	$tmr_dash_fx.start(duration)

func _on_tmr_update_timeout():
	#### UN TIMER UNIDO A LA FUNCIÓN LOAD_DASH, LO QUE HACE ES IR ACTUALIZANDO LA REGIÓN VISIBLE DEL SPRITE DE CARGADO
	var spr = $spr_dash_load
	var aux_rect=spr.get_rect()
	var aux_pos=aux_rect.position
	var aux_size = aux_rect.size
	
	auxHeight+=auxDuration*260
	aux_size.y=auxHeight
	var new_rect=Rect2(aux_pos,aux_size)
	$spr_dash_load.region_rect=new_rect
	
	#### SOLO SI NO SE HA LLEGADO A LA ALTURA MAXIMA DEL SPRITE, REPETIR ESTE CONTADOR
	if auxHeight<260:
		$tmr_update.start(auxDuration)



func _on_tmr_dash_fx_timeout():
	$dash_fx.visible=false


func _on_tmr_updateGrenade_timeout():
	$spr_grenade.modulate.a+=(auxGrenadeCD/60)/auxGrenadeCD
	if $spr_grenade.modulate.a<1:
		$tmr_updateGrenade.start(auxGrenadeCD/60)
	else:
		$spr_grenade.modulate=Color("ffffff")
