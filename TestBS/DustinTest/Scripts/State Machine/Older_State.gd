extends Node
class_name Older_State

signal Transitioned

# Raycasting
@onready var chest_ray = %Chest
@onready var head_climb_rays = %HeadClimbRays

@export var older_brother: Node3D

# Climbing vars
var called_climb = false
var called_grab: bool = false
var can_jump = true
var grab_start = false
var can_turn: bool = true

@export var walk_speed: float = 2.5
@export var run_speed: float = 4.0
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
	
func _process(delta):
	var fps = Engine.get_frames_per_second()
	var lerp_interval = velocity_move / fps
	var lerp_position = older_brother.global_transform.origin + lerp_interval
	
	if fps > 60:
		mesh.top_level = true
		mesh.global_transform.origin = mesh.global_transform.origin.lerp(lerp_position, 20 * delta)
	else:
		mesh.global_transform = older_brother.global_transform
		mesh.top_level = false

# Climbing functions
func can_climb():
	if !chest_ray.is_colliding():
		return false
	for ray in head_climb_rays.get_children():
		if ray.is_colliding():
			return false
	return true
