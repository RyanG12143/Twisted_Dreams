extends Sprite2D

var open:bool = false

func _ready():
	self_modulate.a = 1.0

func state_changed():
	if(open):
		self_modulate.a = 0.2
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	else:
		self_modulate.a = 1.0
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)


func open_door():
	open = true
	state_changed()

func close_door():
	open = false
	state_changed()
	
