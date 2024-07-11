extends Area2D
## Triggers that call somethin to happen when a character walks through it.

## Is this trigger box a trigger for changing whether follow state is enabled.
@export var follow_trigger:bool = false
##Is this trigger box for bringing up a dialog box
@export var dialog_trigger:bool = false
##Dialog to send to the dialog box
@export var char_1_dialog: Array[String] = []
@export var char_2_dialog: Array[String] = []

signal Trigger_Activated
signal Send_Dialog(char_1, char_2)

## Whether or not the trigger is activated.
var trigger_activated:bool = false

## Detects if player enters/exits the trigger area and automatically activates it.
func _trigger_dectected_body(body):
	if((!trigger_activated) and body.is_in_group("Player") and globals.character_control != 0):
		trigger_activated = true
		if(follow_trigger):
			globals.toggle_follow_state()
		elif(dialog_trigger):
			emit_signal("Send_Dialog", char_1_dialog, char_2_dialog)
		else:
			emit_signal("Trigger_Activated")
