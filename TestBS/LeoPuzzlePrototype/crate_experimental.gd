extends RigidBody2D
class_name Crate
## Movable, weighted crates.
## @experimental

## Original position of the crate.
var reset_position:Vector2
## The force applied to pushable objects(crates).
var push_force:float = 0.0

## Sets the reset position for the crate.
func _ready():
	reset_position = position

## Resets crate position if input pressed.
func _process(delta):
	if(Input.is_action_pressed("ui_crate_reset")):
		position = reset_position

## (NOT WORKING)
func _on_area_2d_body_entered(object):
	if (object is Character_One or Character_Two or Crate) and !(object==self) and !(object is TileMap):
		if(object is Crate):
			
		else:
			apply_central_impulse(object.velocity.normalized() * object.push_force)
