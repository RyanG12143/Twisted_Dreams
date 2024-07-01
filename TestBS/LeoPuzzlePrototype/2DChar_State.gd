extends Node
class_name State
## An abstract state class for 2D characters that cann be used to control animations.

## The animation player.
var anim: AnimationPlayer = null
## The state machine.
var state_machine:Node = null

## Signal for when states are transitioned.
signal Transitioned

## Assigns state machine.
func _ready():
	state_machine = get_parent()
	if(owner != null):
		anim = owner.anim


func Enter():
	pass

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass

func input(event):
	pass
