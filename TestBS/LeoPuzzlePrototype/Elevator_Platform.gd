extends Path2D

## How far the platform moves (y direction) from a single input
const MOVE_DISTANCE:int = 144

@export var speed = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

## Number of active inputs affecting the elevator platform.
var inputs:int = 0
## How many inputs are required to get the elevator platform to it's highest point.
@export var inputs_required:int = 3

var timer:float = 0.0

## Move direction of platform. (-1=down, 0=stationary, 1=up)
var move_direction:int = 0

var moving:bool = false

var move_inputs:Array = []

var move_queue:int = 0

func _ready():
	animation.play("move_up")
	animation.stop()

func _process(delta):
	if (move_queue > 0 and !moving):
		moving = true
		move_queue -= 1
		
		var temp:int = 0
		
		for input in move_inputs:
			temp += input
		if(temp > 0):
			move_direction = 1
		elif(temp < 0):
			move_direction = -1
		else:
			move_direction = 0
			move_queue = 0
			move_inputs.clear()
		
		move_up_or_down()

func move_up_or_down():
		
	if(move_direction == 1):
		animation.play("move_up")
		await get_tree().create_timer(1.0).timeout
		animation.stop()
		position.y -= MOVE_DISTANCE
		animation.seek(0, true)
		move_inputs.erase(move_direction)
	if(move_direction == -1):
		animation.play("move_up")
		animation.stop()
		position.y += MOVE_DISTANCE
		animation.seek(1, true)
		animation.play("move_down")
		await get_tree().create_timer(1.0).timeout
		animation.stop()
		animation.seek(1, true)
		move_inputs.erase(move_direction)
		
	move_direction = 0
	moving = false

## Handles additions of inputs.
func add_input():
	inputs += 1
	if(inputs <= inputs_required):
		move_inputs.append(1)
		move_queue += 1

## Handles removals of inputs.
func remove_input():
	inputs -= 1
	if(inputs >= 0):
		move_inputs.append(-1)
		move_queue += 1
