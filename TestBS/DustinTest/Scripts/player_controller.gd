extends CharacterBody3D

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

# Ready method
func _ready() -> void:
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

# Physics process
func _physics_process(delta: float) -> void:
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

	move_and_slide()


func _process(_delta: float) -> void:
	_player_visual.global_transform = _physics_body_trans_last.interpolate_with(
		_physics_body_trans_current,
		Engine.get_physics_interpolation_fraction()
	)
