class_name Enemy_State
extends Node
## Base class for enemy state
##
## Contains virtual methods to be overidden, and a signal to trigger state changes

## Used in state machine to switch between state and next_state
## [br][br]
## [param state] is the [Enemy_State] in which is emitting the signal
## [br][br]
## [param next_state] is the name of the [Enemy_State] in the tree in which the script wants to transition to
signal transitioned(state:Enemy_State, next_state:String)

## This should be called when the state is set to current state in the State Machine
func enter(body:CharacterBody2D):
	pass

## This should be called when the state is being replaced from current state in the State Machine
func exit(body:CharacterBody2D):
	pass

## Call in _physics_process to handle movement
func physics_update(body:CharacterBody2D, delta:float):
	pass

## Call in _process to update State
func update(body:CharacterBody2D, delta:float):
	pass
