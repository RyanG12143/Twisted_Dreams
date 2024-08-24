class_name Chase_NPC
extends CharacterBody3D

## Emitted when NPC has no more positions to path towards
signal finished_path

## Movement speed of NPC
@export var speed = 5.0
## Turn speed of NPC
@export var turn_Speed:float = 20
## Head to turn towards observable Character/NPC
@export var head:MeshInstance3D
## Node3D containing all waypoints for npc travel to
@export var target:Node3D
## Distance from target in which character will speed up
@export var distance_target:float = 10


## Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
## Enabling changing of speed while allowing going back to default
var speed_multiplyer:float = 1
## Boolean for waiting at desired waypoint
var waiting:bool = false
## 
var vaulting:bool = false

var vault_looking = Vector3.ZERO


## Navigation agent to provide pathfinding for npc
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
## Timer to set wait time
@onready var wait_timer:Timer = $Wait_Timer
## Marker to enable correct desired rotation
@onready var rotation_helper:Marker3D = Marker3D.new()


func _ready():
	add_child(rotation_helper)
	
	if not target:
		return
	nav_agent.target_position = target.global_position


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not vaulting:
		velocity.y -= gravity * delta
	
	if waiting:
		_turn(delta, nav_agent.get_next_path_position())
		_head_turn_clamp(delta, nav_agent.target_position, 90)
		return
	
	if vaulting:
		_turn(delta, vault_looking)
		_head_turn_clamp(delta, nav_agent.target_position, 90)
		return
	
	if not target:
		return
	
	nav_agent.target_position = target.global_position
	
	var dist:float = global_position.distance_to(nav_agent.target_position)
	speed_multiplyer = clampf((dist - distance_target + 1), 1, 10)
	
	_turn(delta, nav_agent.get_next_path_position())
	_head_turn_clamp(delta, nav_agent.target_position, 90)
	
	
	# Character movement
	var direction = ($Front.global_position - global_position).normalized()
	if direction:
		velocity.x = direction.x * speed * speed_multiplyer
		velocity.z = direction.z * speed * speed_multiplyer
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplyer)
		velocity.z = move_toward(velocity.z, 0, speed * speed_multiplyer)
	
	move_and_slide()


func _process(delta_):
	pass


## Turns the chracter towards target
func _turn(delta, target:Vector3):
	rotation_helper.look_at(Vector3(target.x, rotation_helper.global_position.y, target.z), Vector3.UP, true)
	var target_rotation = Quaternion(rotation_helper.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_Speed)
	
	global_transform.basis = Basis(next_rotation)


## Turns the chracter head towards target
func _head_turn_clamp(delta, target:Vector3, clamp:float):
	
	var new_transform = head.global_transform.looking_at(Vector3(target.x,target.y + 1.3,target.z), Vector3.UP, true)
	head.global_transform = head.global_transform.interpolate_with(new_transform, delta * 5)
	head.rotation_degrees.y = clampf(head.rotation_degrees.y, -clamp, clamp)
	
	head.scale = Vector3(1,1,1) # Scale gets weird with global transforms so this puts it back to normal


func vault(height:float, direction:Vector3):
	print("Vault")
	vaulting = true
	
	var tween = create_tween()
	var target_height = Vector3(global_position.x, height, global_position.z)
	direction.y = 0
	direction = direction.normalized()
	var target_end = Vector3(target_height - (direction * .5))
	vault_looking = target_end - (direction * 2)
	
	#tween.tween_property(self, "global_rotation", )
	tween.tween_property(self, "global_position", target_height, 1)
	tween.tween_property(self, "global_position", target_end, 1)
	tween.tween_callback(vault_fin)


func vault_fin():
	vaulting = false
