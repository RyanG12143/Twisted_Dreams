extends CharacterBody3D
class_name Brother_Older

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

# Ready function
func _ready():
	# Setting up key values and action values for player input
	_camera = owner.get_node("%MainCamera3D")
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
	var cam_dir: Vector3 = _camera.global_transform.basis.z
	
	# Quitting to menu
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")
	
	move_and_slide()

# Process function
func _process(delta):
	pass
