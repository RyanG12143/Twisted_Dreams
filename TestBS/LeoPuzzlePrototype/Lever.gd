extends AnimatedSprite2D
## Levers that have two states, either red or green.

signal Lever_Red
signal Lever_Green

## Whether or not the lever is green.
var lever_green:bool = false

## Sets lever to red by default.
func _ready():
	set_frame(0)

## Detects if player enters the lever area and swaps it's state.
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
