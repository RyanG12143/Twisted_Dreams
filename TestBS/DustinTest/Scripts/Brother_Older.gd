extends "res://TestBS/DustinTest/Scripts/player_controller.gd"

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

# Ready function
func _ready():
	super()
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
	super(delta)
	
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

