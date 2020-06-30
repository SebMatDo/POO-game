extends Button

######  ESTE ES EL MODELO DE LOS BOTONES PARA QUE HAGAN EL EFECTO DE SER SELECCIONADOS, SIN TENER QUE PONER CADA SEÑAL A CADA BOTON
var action=""

func _ready():
# warning-ignore:return_value_discarded
	low_alpha()
	connect("mouse_entered",self,"high_alpha")
# warning-ignore:return_value_discarded
	connect("mouse_exited",self,"low_alpha")
	
# warning-ignore:return_value_discarded
	connect("visibility_changed",self,"low_alpha")
	
func low_alpha():
	self_modulate.a=0.5
func high_alpha():
	self_modulate.a=1
