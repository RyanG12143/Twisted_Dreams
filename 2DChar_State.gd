extends Node
class_name State
## An abstract state class for 2D characters that cann be used to control animations.

## The parent of the state, in this case, the CharacterBody2D.
var parent = null
## The animation player.
var anim: AnimationPlayer = null
## The state machine.
var state_machine:Node = null

## Signal for when states are transitioned.
signal Transitioned

## Assigns state machine and parent.
func _ready():
	state_machine = get_parent()
	if(state_machine.character_num == 1):
		parent = get_tree().get_root().get_node("world/character_one")
	elif(state_machine.character_num == 2):
		parent = get_tree().get_root().get_node("world/character_two")
	if(parent != null):
		anim = parent.anim


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
