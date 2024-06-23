extends Path2D
class_name Elevator_Platform

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

## Does the platform go up or down?
@export var goes_down:bool = false

## Starting level of the platform, must be between 0 and 1.
@export var starting_progress:float = 0.0

## Move direction of platform. (-1=down, 0=stationary, 1=up)
var move_direction:int = 0

## Whether or not the platform currently moving.
var moving:bool = false

## These two variables store information regarding where the platform needs to move to next.
var move_inputs:Array = []
var move_queue:int = 0

## Height that the platform is headed towards.
var target_height:float = 0

## Array of valid bodies directly underneath the platform, and are therefore stopping it to prevent getting crushed.
var overlapping_bodies:Array = []

## Are there objects stopping the platform from going down.
var bodies_below:bool = false

## Setting the correct frame.
func _ready():
	animation.play("move_up")
	animation.seek(starting_progress * 10, true)
	animation.pause()
	target_height = starting_progress
	path.set_progress_ratio(starting_progress)

## Used to determine what the move direction of the platform should be.
func _process(delta):
	if((path.get_progress_ratio() != target_height)):
		animation.play("move_up")
		if(path.get_progress_ratio() < target_height):
			animation.speed_scale = 1
		elif(path.get_progress_ratio() > target_height && !bodies_below):
			animation.speed_scale = -1
		else:
			animation.pause()
		if(abs(path.get_progress_ratio()-target_height) < 0.001):
			path.set_progress_ratio(target_height)
			animation.pause()
	else:
		animation.pause()

## Handles additions of inputs.
func add_input():
	inputs += 1
	if(inputs <= inputs_required):
		if(!goes_down):
			target_height += 0.1
		else:
			target_height -= 0.1

## Handles removals of inputs.
func remove_input():
	inputs -= 1
	if(inputs >= 0):
		if(goes_down):
			target_height += 0.1
		else:
			target_height -= 0.1


func _on_area_2d_body_entered(body):
	if(body.is_in_group("Can_Press_Buttons")):
		if(!overlapping_bodies):
			bodies_below = true
		overlapping_bodies.append(body)



func _on_area_2d_body_exited(body):
	if(body.is_in_group("Can_Press_Buttons")):
		overlapping_bodies.erase(body)
		if(!overlapping_bodies):
			bodies_below = false
