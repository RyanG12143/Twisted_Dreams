extends CharacterBody3D
class_name Player_Camera

@export var mouse_sensitivity: float = 0.05

# Camera vars
@onready var _player_pcam: PhantomCamera3D
@onready var _player_direction: Node3D = %PlayerVisual
@onready var ray_direction: Node3D = %Rays

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360


@onready var _camera: Camera3D

@onready var _player_visual: Node3D = $"."

var last_position: Vector3 = Vector3(0, 0, 0)


# Ready function
func _ready():
	# Setting up key values and action values for player input
	_camera = owner.get_node("%MainCamera3D")
	_player_visual.top_level = true
	
	_player_pcam = owner.get_node("%PhantomCamera3D")
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
	#print(last_position > $PlayerVisual.global_position)
	#print($PlayerVisual.global_position)
	#last_position = $PlayerVisual.global_position
	


	var cam_dir: Vector3 = _camera.global_transform.basis.z
	
	# Quitting to menu
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("uid://5cd0615q4al1")
	
	if Input.is_action_just_released("3Dzoom_in") && _player_pcam.get_spring_length() > 1.5:
		_player_pcam.set_spring_length(_player_pcam.get_spring_length() - 0.2)

	if Input.is_action_just_released("3Dzoom_out") && _player_pcam.get_spring_length() < 20:
		_player_pcam.set_spring_length(_player_pcam.get_spring_length() + 0.2)

	
	_rotate_step_up_seperation_ray()
	move_and_slide()
	_snap_down_to_stairs_check()

# Snapping down stairs
var _was_on_floor_last_frame = false
var _snapped_to_stairs_last_frame = false

func _snap_down_to_stairs_check():
	var did_snap = false
	if not is_on_floor() and velocity.y <= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_frame) and $PlayerVisual/Rays/StairsBelowRayCast3D.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0,max_step_down,0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
		
	_was_on_floor_last_frame = is_on_floor()
	_snapped_to_stairs_last_frame = did_snap

# Rotate step up rays
@onready var _initial_seperation_ray_dist = abs($StairsBelowRayCast3D_F.position.z)
var _last_xz_vel : Vector3 = Vector3(0,0,0)
func _rotate_step_up_seperation_ray():
	var xz_vel = velocity * Vector3(1,0,1)
	
	if xz_vel.length() < 0.1:
		xz_vel = _last_xz_vel
	else:
		_last_xz_vel = xz_vel
	
	var xz_f_ray_pos = xz_vel.normalized() * _initial_seperation_ray_dist
	$StairsBelowRayCast3D_F.global_position.x = self.global_position.x + xz_f_ray_pos.x
	$StairsBelowRayCast3D_F.global_position.z = self.global_position.z + xz_f_ray_pos.z
	
	var xz_l_ray_pos = xz_f_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(-50))
	$StairsBelowRayCast3D_L.global_position.x = self.global_position.x + xz_l_ray_pos.x
	$StairsBelowRayCast3D_L.global_position.z = self.global_position.z + xz_l_ray_pos.z
	
	var xz_r_ray_pos = xz_f_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(50))
	$StairsBelowRayCast3D_R.global_position.x = self.global_position.x + xz_r_ray_pos.x
	$StairsBelowRayCast3D_R.global_position.z = self.global_position.z + xz_r_ray_pos.z
	
	# To prevent character from running up walls, we do a check for how steep
	# the slope in contact with our seperation ray is
	$StairsBelowRayCast3D_F/RayCast3D.force_raycast_update()
	$StairsBelowRayCast3D_L/RayCast3D.force_raycast_update()
	$StairsBelowRayCast3D_R/RayCast3D.force_raycast_update()
	var max_slope_ang_dot = Vector3(0,1,0).rotated(Vector3(1.0,0,0), self.floor_max_angle).dot(Vector3(0,1,0))
	var any_too_steep = false
	if $StairsBelowRayCast3D_F/RayCast3D.is_colliding() and $StairsBelowRayCast3D_F/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	if $StairsBelowRayCast3D_L/RayCast3D.is_colliding() and $StairsBelowRayCast3D_L/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	if $StairsBelowRayCast3D_R/RayCast3D.is_colliding() and $StairsBelowRayCast3D_R/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
		
	$StairsBelowRayCast3D_F.disabled = any_too_steep
	$StairsBelowRayCast3D_L.disabled = any_too_steep
	$StairsBelowRayCast3D_R.disabled = any_too_steep

# Process function
func _process(delta):
	pass
