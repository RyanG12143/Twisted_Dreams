extends Path2D

## How far the platform moves (y direction) from a single input
const MOVE_DISTANCE:int = 144

## The path.
@onready var path = $PathFollow2D

## The animation player.
@onready var animation = $AnimationPlayer

## Number of active inputs affecting the elevator platform.
var inputs:int = 0

## How many inputs are required to get the elevator platform to it's highest point.
@export var inputs_required:int = 3

## Move direction of platform. (-1=down, 0=stationary, 1=up)
var move_direction:int = 0

## Whether or not the platform currently moving.
var moving:bool = false

## These two variables store information regarding where the platform needs to move to next.
var move_inputs:Array = []
var move_queue:int = 0

var target_height:float = 0

## Setting the correct frame.
func _ready():
	animation.play("move_up")
	animation.stop()

## Used to determine what the move direction of the platform should be.
func _process(delta):
	if($PathFollow2D.get_progress_ratio() != target_height):
		animation.play("move_up")
		if($PathFollow2D.get_progress_ratio() < target_height):
			animation.speed_scale = 1
		elif($PathFollow2D.get_progress_ratio() > target_height):
			animation.speed_scale = -1
	else:
		animation.stop()
	
	#if (move_queue > 0 and !moving):
		#moving = true
		#move_queue -= 1
		#
		#var temp:int = 0
		#
		#for input in move_inputs:
			#temp += input
		#if(temp > 0):
			#move_direction = 1
		#elif(temp < 0):
			#move_direction = -1
		#else:
			#move_direction = 0
			#move_queue = 0
			#move_inputs.clear()
		#
		#move_up_or_down()

## Moves the platform up or down, according to the inputs given.
#func move_up_or_down():
	#if(move_direction == 1):
		#animation.play("move_up")
		#await get_tree().create_timer(1.0).timeout
		#animation.stop()
		#position.y -= MOVE_DISTANCE
		#animation.seek(0, true)
		#move_inputs.erase(move_direction)
	#if(move_direction == -1):
		#animation.play("move_up")
		#animation.stop()
		#position.y += MOVE_DISTANCE
		#animation.seek(1, true)
		#animation.play("move_down")
		#await get_tree().create_timer(1.0).timeout
		#animation.stop()
		#animation.seek(1, true)
		#move_inputs.erase(move_direction)
		#
	#move_direction = 0
	#moving = false

## Handles additions of inputs.
func add_input():
	inputs += 1
	if(inputs <= inputs_required):
		target_height += 0.1
		#move_inputs.append(1)
		#move_queue += 1

## Handles removals of inputs.
func remove_input():
	inputs -= 1
	if(inputs >= 0):
		target_height -= 0.1
		#move_inputs.append(-1)
		#move_queue += 1
