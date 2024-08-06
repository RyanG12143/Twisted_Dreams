extends Node
class_name Older_State

signal Transitioned

# Raycasting
@onready var chest_ray = %Chest
@onready var head_climb_rays = %HeadClimbRays
@onready var ledge_rays = %LedgeRays
@onready var chest_rays = %ChestRays
@onready var ledge_height = %LedgeHeight
@onready var lip_rays = %LipRays
@onready var player_normal = %PlayerNormal
@onready var _player_stair_rays: Node3D = $PlayerVisual/Rays/Stair_Rays

@export var older_brother: Node3D

# Climbing vars
var called_climb = false
var called_grab: bool = false
var can_jump = true
var grab_start = false
var can_turn: bool = true

@export var walk_speed: float = 4.0
@export var run_speed: float = 8.0 #8.0 normally
@export var strafe_speed: float = 1.0
@export var turn_speed: float = 20
@export var movement_speed: float = walk_speed
@export var JUMP_VELOCITY: float = 4.0
@export var enable_gravity = true

@onready var _player_visual: Node = $"."
@onready var mesh = %PlayerVisual
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var movement_enabled: bool = true

# New movement vars
var direction: Vector3 = Vector3.FORWARD
var velocity_move: Vector3 = Vector3.ZERO
var acceleration = 5

# Turning Vars
## Marker to enable correct desired rotation
@onready var rotation_helper:Marker3D = Marker3D.new()

func _ready():
	add_child(rotation_helper)

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(delta: float):
	# Add gravity.
	if !older_brother.is_on_floor() and enable_gravity:
		older_brother.velocity.y -= gravity * delta
	
	if ledge_height.is_colliding():
		player_normal.global_transform.origin.y = ledge_height.get_collision_point().y - 0.01
		
func _process(delta):
	#var fps = Engine.get_frames_per_second()
	#var lerp_interval = velocity_move / fps
	#var lerp_position = older_brother.global_transform.origin + lerp_interval
	pass
	
	#if fps > 60:
		#mesh.top_level = true
		#mesh.global_transform.origin = mesh.global_transform.origin.lerp(lerp_position, 40 * delta)
	#else:
		#mesh.global_transform = older_brother.global_transform
		#mesh.top_level = false

# Climbing functions
func can_climb():
	for ray in head_climb_rays.get_children():
		if ray.is_colliding():
			return false
	return true

func can_grab():
	var lips_colliding
	for lip_ray in lip_rays.get_children():
		if not lip_ray.is_colliding():
			lips_colliding = false
	if lips_colliding != false:
		for ledge_ray in ledge_rays.get_children():
			if not ledge_ray.is_colliding():
				return true
	for chest_ray in chest_rays.get_children():
		if not chest_ray.is_colliding():
			return false
	if ledge_height.is_colliding() and ledge_height.get_collision_point().y != 0:
		return true
	return false

