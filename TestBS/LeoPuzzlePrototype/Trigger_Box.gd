extends Sprite2D
## Triggers that call somethin to happen when a character walks through it.

signal Trigger_Activated

@onready var Area:Area2D = $Area2D

## Whether or not the trigger is activated.
var trigger_activated:bool = false

## Detects if player enters the trigger area and automatically activates it.
func _on_area_2d_body_entered(body):
	if((!trigger_activated) and body.is_in_group("Player")):
		trigger_activated = true
		emit_signal("Trigger_Activated")
