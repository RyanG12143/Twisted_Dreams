extends Sprite2D
class_name Red_Button

signal Button_Pressed
signal Button_Released

var overlapping_bodies:Array = []

func _on_area_2d_body_entered(body):
	if(!overlapping_bodies):
		emit_signal("Button_Pressed")
	if(body.is_in_group("Can_Press_Buttons")):
		overlapping_bodies.append(body)

func _on_area_2d_body_exited(body):
	if(body.is_in_group("Can_Press_Buttons")):
		overlapping_bodies.erase(body)
	if(!overlapping_bodies):
		emit_signal("Button_Released")
