extends AnimatedSprite2D
class_name Floor_Button
## Button with two states, pressed or released.

signal Button_Pressed
signal Button_Released

## Whether or not the most recent action applied to the button was pressing.
var recent_pressed:bool = false
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
		recent_pressed = true
		while (frame != 3 and recent_pressed == true):
			frame += 1
			await get_tree().create_timer(0.03).timeout

## Handles bodies being removed from the button.
func _on_area_2d_body_exited(body):
	if(body.is_in_group("Can_Press_Buttons")):
		overlapping_bodies.erase(body)
		if(!overlapping_bodies):
			emit_signal("Button_Released")
			recent_pressed = false
			while (frame != 0 and recent_pressed == false):
				frame -= 1
				await get_tree().create_timer(0.03).timeout
