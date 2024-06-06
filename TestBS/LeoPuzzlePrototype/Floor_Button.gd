extends AnimatedSprite2D
class_name Floor_Button
## Button with two states, pressed or released.

signal Button_Pressed
signal Button_Released

## Array of valid bodies overlapping with the button, and are therefore pressing it.
var overlapping_bodies:Array = []

## Sets default frame.
func _ready():
	frame = 0

## Handles bodies pressing the button.
func _on_area_2d_body_entered(body):
	if(body.is_in_group("Can_Press_Buttons")):
		if(!overlapping_bodies):
			emit_signal("Button_Pressed")
		overlapping_bodies.append(body)
		if (frame != 3):
			frame = 0
			await get_tree().create_timer(0.02).timeout
			frame = 1
			await get_tree().create_timer(0.02).timeout
			frame = 2
			await get_tree().create_timer(0.02).timeout
			frame = 3

## Handles bodies being removed from the button.
func _on_area_2d_body_exited(body):
	if(body.is_in_group("Can_Press_Buttons")):
		overlapping_bodies.erase(body)
		if(!overlapping_bodies):
			emit_signal("Button_Released")
			if (frame != 0):
				frame = 3
				await get_tree().create_timer(0.02).timeout
				frame = 2
				await get_tree().create_timer(0.02).timeout
				frame = 1
				await get_tree().create_timer(0.02).timeout
				frame = 0
