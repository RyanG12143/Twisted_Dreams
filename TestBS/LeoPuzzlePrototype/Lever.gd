extends AnimatedSprite2D

signal Lever_Red
signal Lever_Green

var lever_green:bool = false

func _ready():
	set_frame(0)

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		if(lever_green):
			set_frame(0)
			lever_green = false
			emit_signal("Lever_Red")
		else:
			set_frame(1)
			lever_green = true
			emit_signal("Lever_Green")
