extends Node
## State Machine which manages the animations for the 2D characters.

## The state in which the character starts.
@export var initial_state : State
## Character number.
@export var character_num:int = 0

## The parent of the state machine, in this case, the CharacterBody2D.
var parent:CharacterBody2D = null
## The current state of the character.
var current_state:State
## Collection of all available states.
var states:Dictionary = {}


## Fills the states Dictionary with states, assigns parent, and sets the current state to the initial state.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
		if(character_num == 1):
			parent = get_tree().get_root().get_node("world/character_one")
		elif(character_num == 2):
			parent = get_tree().get_root().get_node("world/character_two")
		
		await get_tree().create_timer(0.01).timeout
		if initial_state:
			initial_state.Enter()
			current_state = initial_state

## Calls the update function of the current state.
func _process(delta):
	if current_state:
		current_state.Update(delta)

## Calls the physics update function of the current state.
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

## Handles the transition between states.
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state

