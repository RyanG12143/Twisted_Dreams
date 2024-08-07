extends ColorCodedMechanic
## Doors, can be open or closed.

@onready var anim:AnimationPlayer = $AnimationPlayer

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
	if(color == "blue"):
		animation = "Blue"
	elif(color == "pink"):
		animation = "Pink"
	elif(color == "orange"):
		animation = "Orange"
	set_frame(0)

## Handles additions of inputs.
func add_input():
	inputs += 1
	if(inputs >= inputs_required):
		open = true
	else:
		open = false
	if(open):
		if(anim.current_animation == ""):
			anim.play("Open")
			anim.speed_scale = 1
		else:
			anim.speed_scale *= -1
		collider.set_deferred("disabled", true)
	else:
		if(anim.current_animation == ""):
			anim.play("Close")
			anim.speed_scale = 1
		else:
			anim.speed_scale *= -1
		collider.set_deferred("disabled", false)

## Handles removals of inputs.
func remove_input():
	inputs -= 1
	if(inputs < inputs_required):
		open = false
	else:
		open = true
	if(open):
		if(anim.current_animation == ""):
			anim.play("Open")
			anim.speed_scale = 1
		else:
			anim.speed_scale *= -1
		collider.set_deferred("disabled", true)
	else:
		if(anim.current_animation == ""):
			anim.play("Close")
			anim.speed_scale = 1
		else:
			anim.speed_scale *= -1
		collider.set_deferred("disabled", false)
