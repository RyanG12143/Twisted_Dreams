extends CharacterBody2D
class_name Character_One

const UP = Vector2(0, -1)
const SLOPE_STOP = 64

var move_speed = 2 * globals.UNIT_SIZE
var move_direction = 0
var gravity = 1200;
var max_jump_velocity
var min_jump_velocity
var is_grounded
var is_jumping = false
var push_force = 100.0

var max_jump_height = 1.0 * globals.UNIT_SIZE
var min_jump_height = 0.15 * globals.UNIT_SIZE
var jump_duration = 0.4

func _ready():
	globals.set_character_one(self)
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta):
	apply_movement()

func _process(delta):
	apply_gravity(delta)
	if(globals.character_control == 1):
		handle_move_input()
	else:
		velocity.x = lerp(float(velocity.x), float(move_speed * 0), get_h_weight())

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func apply_movement():
	move_and_slide()
	is_grounded = is_on_floor()
	if(is_grounded):
		is_jumping = false
		
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider() is Crate:
			if (move_direction != 0 && abs(collision.get_collider().position.y - position.y) < 25):
				collision.get_collider().slide(Vector2(move_direction, 0) * push_force)
				
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
	
func get_h_weight():
	return 0.2 if is_grounded else 0.05

