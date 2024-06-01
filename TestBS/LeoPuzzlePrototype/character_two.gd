extends CharacterBody2D
class_name Character_Two
## Everything related to character two.

## Upwards direction.
const UP:Vector2 = Vector2(0, -1)
## The force applied to pushable objects(crates).
const  push_force:float = 100.0

## Horizontal movement speed.
var move_speed:float = 2 * globals.UNIT_SIZE
## Movement direction of the character(-1=left, 0=stationary, 1=right).
var move_direction:int = 0
## Gravity(effects how far the character can jump and how fast they fall).
var gravity:float = 1200
## Maximum jump velocity.
var max_jump_velocity:float
## Minimum jump velocity.
var min_jump_velocity:float
## Whether or not the character is touching the ground.
var is_grounded:bool
## Whether or not the character is jumping.
var is_jumping:bool = false
## Maximum jump height.
var max_jump_height:float = 1.0 * globals.UNIT_SIZE
## Minimum jump height.
var min_jump_height:float = 0.15 * globals.UNIT_SIZE
## Duration of a jump.
var jump_duration:float = 0.4

## Sets some default values.
func _ready():
	globals.set_character_two(self)
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

## Apply movement.
func _physics_process(delta):
	apply_movement()

## Apply gravity and handle movement input.
func _process(delta):
	apply_gravity(delta)
	if(globals.character_control == 2):
		handle_move_input()
	else:
		velocity.x = lerp(float(velocity.x), float(move_speed * 0), get_h_weight())

## Apply effects of gravity.
func apply_gravity(delta):
	velocity.y += gravity * delta

## Apply effects of movement.
func apply_movement():
	move_and_slide()
	is_grounded = is_on_floor()
	if(is_grounded):
		is_jumping = false
	
#	for index in get_slide_collision_count():
	#	var collision = get_slide_collision(index)
	#	if collision.get_collider() is Crate:
		#	if (move_direction != 0 && abs(collision.get_collider().position.y - position.y) < 25):
		#		collision.get_collider().slide(Vector2(move_direction, 0) * push_force)
	
## Handle movement input.
func handle_move_input():
	move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	if move_direction == -1:
		get_node("Sprite2D").flip_h = true
	elif move_direction == 1:
		get_node("Sprite2D").flip_h = false
	if(Input.is_action_pressed("ui_jump") && !is_jumping):
		velocity.y = max_jump_velocity
		is_jumping = true
	if(is_jumping && !Input.is_action_pressed("ui_jump") && (velocity.y < min_jump_velocity)):
		velocity.y = min_jump_velocity
		
	velocity.x = lerp(float(velocity.x), float(move_speed * move_direction), get_h_weight())

## Gets current horizontal weight of character movement.
func get_h_weight():
	return 0.2 if is_grounded else 0.05
