extends ColorCodedMechanic
class_name Floor_Button
## Button with two states, pressed or released.

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var audio:AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var button_press_sound:AudioStreamWAV = null
@export var button_release_sound:AudioStreamWAV = null

signal Button_Pressed
signal Button_Released

## Whether or not the most recent action applied to the button was pressing.
var recent_pressed:bool = false
## Array of valid bodies overlapping with the button, and are therefore pressing it.
var overlapping_bodies:Array = []

## Sets default frame.
func _ready():
	if(color == "blue"):
		animation = "Blue"
	elif(color == "pink"):
		animation = "Pink"
	elif(color == "orange"):
		animation = "Orange"
	set_frame(0)

## Handles bodies pressing the button.
func _on_area_2d_body_entered(body):
	if(body.is_in_group("Can_Press_Buttons")):
		if(!overlapping_bodies):
			emit_signal("Button_Pressed")
			var temp = get_frame()
			anim.stop()
			anim.play("Press")
			set_frame(temp)
		overlapping_bodies.append(body)

## Handles bodies being removed from the button.
func _on_area_2d_body_exited(body):
	if(body.is_in_group("Can_Press_Buttons")):
		overlapping_bodies.erase(body)
		if(!overlapping_bodies):
			emit_signal("Button_Released")
			var temp = get_frame()
			anim.stop()
			anim.play("Release")
			set_frame(temp)

func play_sound():
	if (!overlapping_bodies):
		audio.stream = button_release_sound
		audio.volume_db = 0
	else:
		audio.stream = button_press_sound
		audio.volume_db = -3
	audio.play()
