extends CharacterBody3D
## Walk path to store
## Cops look at passerby
## Inverse Loop


@export var speed = 5.0
@export var turn_Speed:float = 10
@export var loop:bool = false
@export var positions_container:Node3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_position:int = 0
var positions:Array[Vector3]
var child_look_at

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var sample:Node3D = $Node3D



func _ready():
	if not positions_container:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	for marker in positions_container.get_children():
		if marker is Marker3D:
			positions.append(marker.global_position)
	
	nav_agent.target_position = positions[current_position]
	current_position += 1
	
	child_look_at = Marker3D.new()
	add_child(child_look_at)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	nav_agent.target_position = positions[current_position - 1]
	
	var target = nav_agent.get_next_path_position()
	child_look_at.look_at(Vector3(target.x, child_look_at.global_position.y, target.z), Vector3.UP, true)
	var target_rotation = Quaternion(child_look_at.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_Speed)
	global_transform.basis = Basis(next_rotation)
	
	var direction = ($Front.global_position - global_position).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _process(delta):
	var targ_pos = nav_agent.target_position
	targ_pos.y = global_position.y
	var dist_targ = global_position.distance_to(targ_pos)
	
	if dist_targ < nav_agent.target_desired_distance:
		nav_agent.emit_signal("target_reached")


func _on_target_reached():
	print("Target")
	if positions.size() > current_position:
		nav_agent.target_position = positions[current_position]
		current_position += 1
	elif loop:
		current_position = 0
		nav_agent.target_position = positions[current_position]
		current_position += 1
