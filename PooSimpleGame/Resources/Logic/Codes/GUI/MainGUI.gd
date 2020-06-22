extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var auxHeight=0
var auxHeightUpdate=0
var auxDuration=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Lb_fps.text="fps: " + str(Engine.get_frames_per_second())
	
	
	
func update_dash(dash):
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
	auxDuration=duration/60
	auxHeight=0
	$spr_dash_load.region_rect=Rect2(0,0,301,0)
	$tmr_update.start(auxDuration)

func _on_tmr_update_timeout():
	var spr = $spr_dash_load
	var aux_rect=spr.get_rect()
	var aux_pos=aux_rect.position
	var aux_size = aux_rect.size
	
	auxHeight+=auxDuration*260
	aux_size.y=auxHeight
	var new_rect=Rect2(aux_pos,aux_size)
	$spr_dash_load.region_rect=new_rect
	
	
	if auxHeight<260:
		$tmr_update.start(auxDuration)
	print(auxHeight, auxDuration)
