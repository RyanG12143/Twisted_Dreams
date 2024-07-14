extends CharacterBody3D
# Walk path to store
# Cops look at passerby
# Inverse Loop


@export var speed = 5.0
@export var turn_Speed:float = 10
@export var loop:bool = false
@export var inverse_loop:bool = false
@export var positions_container:Node3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_marker:int = 0
var traverse_direction:int = 1
var markers:Array[Marker3D]
var child_look_at
var waiting:bool = false
var wait_turn_target:Vector3 = Vector3.ZERO

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var sample:Node3D = $Node3D
@onready var timer:Timer = $Timer



func _ready():
	if not positions_container:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	for marker in positions_container.get_children():
		if marker is Marker3D:
			markers.append(marker)
	
	nav_agent.target_position = markers[current_marker].global_position
	
	child_look_at = Marker3D.new()
	add_child(child_look_at)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if waiting:
		_turn(delta, wait_turn_target)
		return
	
	nav_agent.target_position = markers[current_marker].global_position
	
	_turn(delta, nav_agent.get_next_path_position())
	
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
	
	var marker = markers[current_marker]
	
	if marker.wait:
		waiting = true
		timer.start(marker.wait_time)
	
	if marker.change_speed:
		if marker.speed_value > 0:
			speed = marker.speed_value
		if marker.speed_multiplyer > 0:
			speed *= marker.speed_multiplyer
	
	if marker.turn_towards:
		wait_turn_target = marker.turn_target.global_position
	else:
		wait_turn_target = global_position
	
	if markers.size() > current_marker + 1 and not (current_marker + (1 * traverse_direction)) < 0:
		current_marker += 1 * traverse_direction
		nav_agent.target_position = markers[current_marker].global_position
		return
	
	if loop and inverse_loop:
		traverse_direction *= -1
		current_marker += 1 * traverse_direction
		nav_agent.target_position = markers[current_marker].global_position
		return
	
	if loop:
		current_marker = 0
		nav_agent.target_position = markers[current_marker].global_position
		return


func _on_wait_timeout():
	waiting = false


func _turn(delta, target:Vector3):
	child_look_at.look_at(Vector3(target.x, child_look_at.global_position.y, target.z), Vector3.UP, true)
	var target_rotation = Quaternion(child_look_at.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_Speed)
	global_transform.basis = Basis(next_rotation)
