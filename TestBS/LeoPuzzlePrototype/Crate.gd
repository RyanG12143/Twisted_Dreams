extends CharacterBody2D
class_name Crate
## Movable, weighted crates.

## Time crates slide for after being moved by the player.
const SLIDE_TIME:float = 1.0

## Essentially a falling speed.
var gravity:int = 20
## Original position of the crate.
var reset_position:Vector2

## Sets the reset position for the crate.
func _ready():
	reset_position = position
	

## Handles physics of the crate.
func _physics_process(delta):
	velocity.y += gravity
	move_and_slide()
	
	
	if(abs(velocity.x) >= 3.0):
		if(velocity.x > 0.0):
			slide(Vector2(velocity.x - 3.0, velocity.y))
		else:
			slide(Vector2(velocity.x + 3.0, velocity.y))
	else:
		velocity.x = 0.0
		
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider() is Crate:
			collision.get_collider().slide(Vector2(velocity.x, 0))
		
	

## Resets crate position if input pressed.
func _process(delta):
	if(Input.is_action_pressed("ui_crate_reset")):
		position = reset_position

## Handles the sliding of the box.
func slide(vector):
	velocity.x = vector.x
	
