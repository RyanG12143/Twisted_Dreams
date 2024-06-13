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
	if(Input.is_action_pressed("ui_crate_reset")):
		reset_state = true

## Prepares crates to be reset.
func _integrate_forces(state):
	if reset_state:
		reset_state = false
		
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		state.transform.origin = reset_position

## Called when crate is being pulled, moves crate to opposite side of player
func _pull_crate():
	set_collision_layer_value(3,false)
	set_collision_mask_value(2,false)
	await get_tree().create_timer(0.14).timeout
	set_deferred("linear_velocity", Vector2(linear_velocity.x/8, linear_velocity.y))
	await get_tree().create_timer(0.01).timeout
	set_collision_layer_value(3,true)
	set_collision_mask_value(2,true)
	
