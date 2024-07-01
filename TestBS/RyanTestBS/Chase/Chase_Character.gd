extends CharacterBody3D


const SPEED = 5.0

@export var loop:bool = false
@export var positionsContainer:Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var currentPosition:int = 0
var positions:Array[Vector3]
var child_look_at

@onready var navAgent:NavigationAgent3D = $NavigationAgent3D
@onready var sample:Node3D = $Node3D



func _ready():
	if not positionsContainer:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	for marker in positionsContainer.get_children():
		if marker is Marker3D:
			positions.append(marker.global_position)
	
	navAgent.target_position = positions[currentPosition]
	currentPosition += 1
	
	child_look_at = Marker3D.new()
	add_child(child_look_at)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var target = navAgent.get_next_path_position()
	
	var direction = (target - global_position).normalized()
	
	
	child_look_at.look_at(target, Vector3.UP, true)
	var target_rotation = Quaternion(child_look_at.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta*1.0)
	global_transform.basis = Basis(next_rotation)
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_target_reached():
	print("Target")
	if positions.size() > currentPosition:
		navAgent.target_position = positions[currentPosition]
		currentPosition += 1
	elif loop:
		currentPosition = 0
		navAgent.target_position = positions[currentPosition]
		currentPosition += 1
