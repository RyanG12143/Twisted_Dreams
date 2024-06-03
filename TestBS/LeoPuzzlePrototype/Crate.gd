extends RigidBody2D
class_name Crate
## Moveable, weighted crates.

## Original position of the crate.
var reset_position:Vector2
## Is the position being reset.
var reset_state:bool = false

## Sets the reset position for the crate.
func _ready():
	reset_position = position
	
## Resets crate position if input pressed.
func _process(delta):
	apply_central_impulse(Vector2(0, 0))
	if(Input.is_action_pressed("ui_crate_reset")):
		reset_state = true

func _integrate_forces(state):
	if reset_state:
		reset_state = false
		
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		state.transform.origin = reset_position
		
