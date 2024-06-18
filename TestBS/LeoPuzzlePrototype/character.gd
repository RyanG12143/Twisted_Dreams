extends CharacterBody2D
## Everything related to character.

## Character number.
@export var character_number:int = 0

@onready var Sprite:Sprite2D = $Sprite2D

@onready var Area:Area2D = $Area2D

## Upwards direction.
const UP:Vector2 = Vector2(0, -1)
## The force applied to pushable objects(crates).
const  push_force:float = 120.0

## Horizontal movement speed.
var move_speed:float = 2 * globals.UNIT_SIZE
## Movement direction of the character(-1=left, 0=stationary, 1=right).
var move_direction:int = 0
## Previous move direction of the character(used to make crate moving less buggy)
var prev_mov_dir:int = 0
## Can previous move direction be set?
var set_pmd_ready:bool = true
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

## Wether or not the character is facing right.
var is_facing_right:bool = true

## Sets some default values.
func _ready():
	if(character_number == 1):
		globals.set_character_one(self)
	elif(character_number == 2):
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
	if(globals.character_control == character_number):
		handle_move_input()
		set_prev_mov_div()
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
	
	for body in Area.get_overlapping_bodies():
		if body is Crate:
			if (body.global_position.x <= global_position.x):
				body.set_deferred("linear_velocity", Vector2(-1.0  * push_force, body.linear_velocity.y))
			else:
				body.set_deferred("linear_velocity", Vector2(1.0  * push_force, body.linear_velocity.y))
	
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider() is Crate:
			var coll:RigidBody2D = collision.get_collider()
			if ((abs(coll.global_position.y - global_position.y) < 10 && character_number == 1) or (abs(coll.global_position.y - global_position.y) < 26 && character_number == 2)):
				if(move_direction != 0 && collision.get_collider().global_position.y > (global_position.y - 5)):
					if(Input.is_action_pressed("crate_pick_up")):
						coll._pull_crate()
						if(coll.global_position.x > global_position.x):
							coll.set_deferred("linear_velocity", Vector2(-4 * push_force, coll.linear_velocity.y))
						else:
							coll.set_deferred("linear_velocity", Vector2(4 * push_force, coll.linear_velocity.y))
					elif(prev_mov_dir == move_direction):
						coll.set_deferred("linear_velocity", Vector2(move_direction * push_force, coll.linear_velocity.y))
			#elif(coll.global_position.y <= global_position.y):
				#if (coll.global_position.x <= global_position.x):
					#coll.set_deferred("linear_velocity", Vector2(-1.0  * push_force, coll.linear_velocity.y))
				#else:
					#coll.set_deferred("linear_velocity", Vector2(1.0  * push_force, coll.linear_velocity.y))

## Handle movement input.
func handle_move_input():
	move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	if move_direction == -1:
		is_facing_right = false
		get_node("Sprite2D").flip_h = true
	elif move_direction == 1:
		is_facing_right = true
		get_node("Sprite2D").flip_h = false
	if(Input.is_action_just_pressed("ui_jump") && !is_jumping):
		velocity.y = max_jump_velocity
		is_jumping = true
	if(is_jumping && !Input.is_action_pressed("ui_jump") && (velocity.y < min_jump_velocity)):
		velocity.y = min_jump_velocity
		
	velocity.x = lerp(float(velocity.x), float(move_speed * move_direction), get_h_weight())

## Gets current horizontal weight of character movement.
func get_h_weight():
	return 0.2 if is_grounded else 0.05
	
## Previous move direction of the character(used to make crate moving less buggy)
func set_prev_mov_div():
	if(set_pmd_ready):
		set_pmd_ready = false
		prev_mov_dir = move_direction
		await get_tree().create_timer(0.1).timeout
		set_pmd_ready = true

