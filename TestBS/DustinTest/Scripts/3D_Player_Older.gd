extends "res://addons/phantom_camera/examples/scripts/3D/player_controller.gd"


var current_speed:float
@export var walk_speed:float = 4.0
@export var sprint_speed:float = 6.0
var stored_speed:float
@export var jump_velocity:float = 4.5
@onready var pivot = $CamOrigin
@export var sens:float = 0.5
var called_climb = false
var can_jump = true
var grab_start = false


# Raycasting
@onready var chest_ray = $PlayerVisual/Rays/Chest
@onready var head_rays = $PlayerVisual/Rays/HeadRays

#camera stuff
@onready var _player_pcam: PhantomCamera3D
@onready var _player_direction: Node3D = %PlayerVisual
@onready var ray_direction: Node3D = %Rays

@export var mouse_sensitivity: float = 0.05

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360




# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	super()
	_player_pcam = get_node("../PhantomCamera3D")

	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#func _input(event):
	#if event is InputEventMouseMotion:
		#pass
		#rotate_y(deg_to_rad(-event.relative.x * sens))
		#pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		#pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))


#camera stuff

func _unhandled_input(event: InputEvent) -> void:
	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
		var active_pcam: PhantomCamera3D
		_set_pcam_rotation(_player_pcam, event)



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








func _physics_process(delta):
	super(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("3Djump") and is_on_floor() and can_jump:
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("3Dsprint"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed

	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("3Dleft", "3Dright", "3Dforward", "3Dbackward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * current_speed
		#velocity.z = direction.z * current_speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, current_speed)
		#velocity.z = move_toward(velocity.z, 0, current_speed)
	var testVelocity: Vector3 = Vector3(velocity.x, 0, velocity.z)
	if testVelocity.length() > 0.2 and !chest_ray.is_colliding():
		var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
		_player_direction.rotation.y = look_direction.angle()
		
	
	move_and_slide()
	
	
	
func _process(delta):
	if Input.is_action_pressed("3Djump") and can_climb():
		grab_ledge()
		
func can_climb():
	if !chest_ray.is_colliding():
		return false
	for ray in head_rays.get_children():
		if ray.is_colliding():
			return false
	return true

func grab_ledge():
	velocity = Vector3.ZERO
	climb_ledge()
	

func climb_ledge():
	if called_climb:
		return
	called_climb = true
	climb()
	
func climb():
	can_jump = false
	var v_move_time = 1
	var h_move_time = 0.4
	var vertical_movement = global_transform.origin + Vector3(0, 1.3, 0)
	var forward_movement = global_transform.origin + (_player_direction.global_transform.basis.z * 1.2)
	forward_movement.y += 1.3
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", vertical_movement, v_move_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", forward_movement, h_move_time).set_trans(Tween.TRANS_LINEAR)
	
	can_jump = true
	called_climb = false
	

