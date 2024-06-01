extends RigidBody2D
class_name Crate
## Movable, weighted crates.
## @experimental

## Original position of the crate.
var reset_position:Vector2
## The force applied to pushable objects(crates).
var push_force:float = 0.0
## The player.
var player:CharacterBody2D
## The state of the crate.
var state:String

## Sets the reset position for the crate.
func _ready():
	state = "stationary"
	reset_position = position

## Resets crate position if input pressed.
func _process(delta):
	print(state)
	match state:
		"stationary":
			linear_velocity.x = 0.0
		"pushed":
			#print(player.move_direction * player.push_force)
			#linear_velocity.x = player.move_direction * player.push_force
			apply_central_impulse(-player.velocity.normalized() * 10)
		"sliding":
			if(abs(linear_velocity.x) >= 3.0):
				if(linear_velocity.x > 0.0):
					slide(Vector2(linear_velocity.x - 3.0, linear_velocity.y))
				else:
					slide(Vector2(linear_velocity.x + 3.0, linear_velocity.y))
			else:
				state = "stationary"
	
	if(Input.is_action_pressed("ui_crate_reset")):
		position = reset_position

## Handles the sliding of the crate.
func slide(vector):
	linear_velocity.x = vector.x

## (NOT WORKING)
func _on_area_2d_body_entered(object):
	if !(object is TileMap):
		if (object is Character_One) and (globals.next_controlled_character == 1):
			player = object
			state = "pushed"
		elif (object is Character_Two) and (globals.next_controlled_character == 2):
			player = object
			state = "pushed"


func _on_area_2d_body_exited(object):
	if (object == player):
		state = "sliding"
