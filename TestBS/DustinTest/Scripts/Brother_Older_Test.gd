extends CharacterBody3D

@export var mouse_sensitivity: float = 0.05

# Raycasting
@onready var chest_ray = $PlayerVisual/Rays/Chest
@onready var head_climb_rays = $PlayerVisual/Rays/HeadClimbRays

# Camera vars
@onready var _player_pcam: PhantomCamera3D
@onready var _player_direction: Node3D = %PlayerVisual
@onready var ray_direction: Node3D = %Rays

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360

# Climbing vars
var called_climb = false
var called_grab: bool = false
var can_jump = true
var grab_start = false
var can_turn: bool = true

@export var WALK_SPEED: float = 2.5
@export var SPRINT_SPEED: float = 4.0
var CURRENT_SPEED: float = WALK_SPEED
@export var JUMP_VELOCITY: float = 3.0
@export var enable_gravity = true

@onready var _camera: Camera3D

@onready var _player_visual: Node3D = $"."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var movement_enabled: bool = true

var _physics_body_trans_last: Transform3D
var _physics_body_trans_current: Transform3D

const KEY_STRINGNAME: StringName = "Key"
const ACTION_STRINGNAME: StringName = "Action"

const INPUT_MOVE_UP_STRINGNAME: StringName = "move_up"
const INPUT_MOVE_DOWM_STRINGNAME: StringName = "move_down"
const INPUT_MOVE_LEFT_STRINGNAME: StringName = "move_left"
const INPUT_MOVE_RIGHT_STRINGNAME: StringName = "move_right"

# Making dictionary for all inputs
var InputMovementDic: Dictionary = {
	INPUT_MOVE_UP_STRINGNAME: {
		KEY_STRINGNAME: KEY_W,
		ACTION_STRINGNAME: INPUT_MOVE_UP_STRINGNAME
	},
	INPUT_MOVE_DOWM_STRINGNAME: {
		KEY_STRINGNAME: KEY_S,
		ACTION_STRINGNAME: INPUT_MOVE_DOWM_STRINGNAME
	},
	INPUT_MOVE_LEFT_STRINGNAME: {
		KEY_STRINGNAME: KEY_A,
		ACTION_STRINGNAME: INPUT_MOVE_LEFT_STRINGNAME
	},
	INPUT_MOVE_RIGHT_STRINGNAME: {
		KEY_STRINGNAME: KEY_D,
		ACTION_STRINGNAME: INPUT_MOVE_RIGHT_STRINGNAME
	},
}



# Ready function
func _ready():
	# Setting up key values and action values for player input
	for input in InputMovementDic:
		var key_val = InputMovementDic[input].get(KEY_STRINGNAME)
		var action_val = InputMovementDic[input].get(ACTION_STRINGNAME)

		_camera = owner.get_node("%MainCamera3D")

		var movement_input = InputEventKey.new()
		movement_input.physical_keycode = key_val
		InputMap.add_action(action_val)
		InputMap.action_add_event(action_val, movement_input)

		_player_visual.top_level = true
	
	_player_pcam = get_node("../PhantomCamera3D")

	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Rotation player cam on Input Event
func _unhandled_input(event: InputEvent) -> void:
	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
		var active_pcam: PhantomCamera3D
		_set_pcam_rotation(_player_pcam, event)

# Setting camera rotation
func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3

		# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
		pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

		# Change the X rotation
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

		# Clamp the rotation in the X axis so it go over or under the target
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)

		# Change the Y rotation value
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

		# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)

		# Change the SpringArm3D node's rotation and rotate around its target
		pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)


# Physics process function
func _physics_process(delta):
	_physics_body_trans_last = _physics_body_trans_current
	_physics_body_trans_current = global_transform

	# Add the gravity.
	if enable_gravity and not is_on_floor():
		velocity.y -= gravity * delta
	
	# If movement isn't enabled cancel all movement
	if not movement_enabled: return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector(
		INPUT_MOVE_LEFT_STRINGNAME,
		INPUT_MOVE_RIGHT_STRINGNAME,
		INPUT_MOVE_UP_STRINGNAME,
		INPUT_MOVE_DOWM_STRINGNAME
	)

	var cam_dir: Vector3 = -_camera.global_transform.basis.z
	
	# Changing between walking and sprinting
	if Input.is_action_pressed("3Dsprint"):
		CURRENT_SPEED = SPRINT_SPEED
	else:
		CURRENT_SPEED = WALK_SPEED
	
	# Handle jump.
	if Input.is_action_just_pressed("3Djump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Getting input direction and moving
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var move_dir: Vector3 = Vector3.ZERO
		move_dir.x = direction.x
		move_dir.z = direction.z

		move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
		if(is_on_floor()):
			velocity.x = move_dir.x * CURRENT_SPEED
			velocity.z = move_dir.z * CURRENT_SPEED

	else:
		if(is_on_floor()):
			velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)
			velocity.z = move_toward(velocity.z, 0, CURRENT_SPEED)
	
	# Quitting to menu
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")

	# setting the look direction
	var testVelocity: Vector3 = Vector3(velocity.x, 0, velocity.z)
	if testVelocity.length() > 0.2 and !chest_ray.is_colliding() and can_turn:
		var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
		_player_direction.rotation.y = look_direction.angle()
	move_and_slide()
	
	

# Process function
func _process(delta):
	#_player_visual.global_transform = _physics_body_trans_last.interpolate_with(
		#_physics_body_trans_current,
		#Engine.get_physics_interpolation_fraction()
	#)
	
	if Input.is_action_pressed("3Djump") and can_climb():
		grab_ledge()
		
	

# Climbing functions
func can_climb():
	if !chest_ray.is_colliding():
		return false
	for ray in head_climb_rays.get_children():
		if ray.is_colliding():
			return false
	return true

func grab_ledge():
	enable_gravity = false
	can_turn = false
	velocity = Vector3.ZERO
	#if called_grab:
		#hanging()
		
	
	#if Input.is_action_just_released("3Djump"):
		#climb_ledge()
	#if Input.is_action_just_released("3Drelease"):
		#release_ledge()
	
	await get_tree().create_timer(2.0).timeout
	called_grab = true
	hanging()

func hanging():
	print("hanging")
	if Input.is_action_pressed("3Djump"):
		climb_ledge()
	if Input.is_action_pressed("3Drelease"):
		release_ledge()
		
		
func hang():
	print("hanging")
	velocity = Vector3.ZERO
	axis_lock_linear_y = true
	enable_gravity = false
	can_turn = false
	if Input.is_action_pressed("3Djump"):
		climb_ledge()
	if Input.is_action_pressed("3Drelease"):
		release_ledge()

func release_ledge():
	enable_gravity = true
	can_turn = true
	called_grab = false

func climb_ledge():
	if called_climb:
		return
	called_climb = true
	climb()
	
func climb():
	can_jump = false
	var v_move_time = 1
	var h_move_time = 0.4
	var vertical_movement = global_transform.origin + Vector3(0, 1.9, 0)
	var forward_movement = global_transform.origin + (_player_direction.global_transform.basis.z * 1.2)
	forward_movement.y += 1.8
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", vertical_movement, v_move_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", forward_movement, h_move_time).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	can_jump = true
	called_climb = false
	called_grab = false
	can_turn = true
	enable_gravity = true

