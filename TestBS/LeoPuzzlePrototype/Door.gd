extends AnimatedSprite2D
## Doors, can be open or closed.

## Collider of the door.
@onready var collider:CollisionShape2D = $StaticBody2D/CollisionShape2D
## Whether or not a door is open.
var open:bool = false
## Number of active inputs affecting the door.
var inputs:int = 0
## How many inputs are required to open a door.
@export var inputs_required:int = 1

## Sets door to visually closed.
func _ready():
	frame = 0

## Handles additions of inputs.
func add_input():
	inputs += 1
	if(inputs >= inputs_required):
		open = true
	else:
		open = false
	if(open):
		frame = 1
		collider.set_deferred("disabled", true)
	else:
		frame = 0
		collider.set_deferred("disabled", false)

## Handles removals of inputs.
func remove_input():
	inputs -= 1
	if(inputs < inputs_required):
		open = false
	else:
		open = true
	if(open):
		frame = 1
		collider.set_deferred("disabled", true)
	else:
		frame = 0
		collider.set_deferred("disabled", false)
