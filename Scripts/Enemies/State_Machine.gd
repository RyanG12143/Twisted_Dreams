class_name State_Machine
extends Node
##

@export var character_body:CharacterBody2D
@export var default_state:Enemy_State

var current_state:Enemy_State
var states:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Enemy_State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	current_state = default_state


func on_child_transition(state:Enemy_State, new_state:String):
	if state != current_state:
		return
	current_state.exit(character_body)
	current_state = states.get(new_state.to_lower())
	current_state.enter(character_body)
