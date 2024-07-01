extends CharacterBody3D


const SPEED = 5.0

@export var loop:bool = false
@export var positionsContainer:Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var currentPosition:int = 0
var positions:Array[Vector3]
var look:Vector3

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


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	var direction = (navAgent.get_next_path_position() - global_position).normalized()
	
	var forward:Vector3 = global_position.direction_to($Marker3D.global_position)
	var dot = direction.dot(forward)
	var angle = rad_to_deg(acos(dot))
	print(angle)
	
	var angle_to_turn = clampf(250 * delta, 0, angle)
	
	var FCrossP = forward.cross(direction)
	if FCrossP.z < 0:
		angle_to_turn *= -1
	print(angle_to_turn)
	
	rotation_degrees.y = move_toward(rotation_degrees.y, angle_to_turn, 10)
	
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
