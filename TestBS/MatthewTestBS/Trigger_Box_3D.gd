extends Area3D

@export var important: bool = false
@export var dialog: Array[Node] = []

var trigger_activated: bool = false
var inside: bool = false

signal Send_Dialog(dialogue)
signal Not_Important

func _process(delta):
	while(inside and !trigger_activated):
		if(Input.is_action_pressed("interact")):
			emit_signal("Not_Important")
			trigger_activated = true

func _on_body_entered(body):
	if((!trigger_activated) and body.is_in_group("Player")):
		if(important and !inside):
			inside = true
		else:
			emit_signal("Not_Important")
			trigger_activated = true
		


func _on_body_exited(body):
	if((!trigger_activated)):
		inside = false
