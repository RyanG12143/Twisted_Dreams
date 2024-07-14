extends CharacterBody3D
# Walk path to store
# Cops look at passerby
# Inverse Loop

signal finished_path

## Movement speed of NPC
@export var speed = 5.0
## Turn speed of NPC
@export var turn_Speed:float = 10
## If true NPC will travel in loop through each waypoint
@export var loop:bool = false
## If true npc will backtrack through waypoints. (1234321)[br][br]
## MUST HAVE LOOP ENABLED
@export var inverse_loop:bool = false
## Node3D containing all waypoints for npc travel to
@export var positions_container:Node3D


## Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
## Enabling changing of speed while allowing going back to default
var speed_multiplyer:float = 1
## Incremental number to keep track of curent desired waypoint
var current_marker:int = 0
## Used for inverse looping
var traverse_direction:int = 1
## Container for all marker destinations for npc
var markers:Array[Marker3D]
## Boolean for waiting at desired waypoint
var waiting:bool = false
## Target to turn towards when reaching waypoint
var wait_turn_target:Vector3 = Vector3.ZERO

## Navigation agent to provide pathfinding for npc
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
## Timer to set wait time
@onready var timer:Timer = $Timer
## Marker to enable correct desired rotation
@onready var child_look_at:Marker3D = Marker3D.new()



func _ready():
	# Disable processing if not given path to follow (Easier to debug)
	if not positions_container:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	_fill_waypoints()
	
	add_child(child_look_at)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Waiting at waypoint
	if waiting:
		_turn(delta, wait_turn_target)
		return
	
	nav_agent.target_position = markers[current_marker].global_position
	
	_turn(delta, nav_agent.get_next_path_position())
	
	# Character movement
	var direction = ($Front.global_position - global_position).normalized()
	if direction:
		velocity.x = direction.x * speed * speed_multiplyer
		velocity.z = direction.z * speed * speed_multiplyer
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplyer)
		velocity.z = move_toward(velocity.z, 0, speed * speed_multiplyer)

	move_and_slide()


func _process(delta):
	var targ_pos = nav_agent.target_position
	targ_pos.y = global_position.y
	var dist_targ = global_position.distance_to(targ_pos)
	
	# Checking if reached target without height
	if dist_targ < nav_agent.target_desired_distance:
		nav_agent.emit_signal("target_reached")


func _on_target_reached():
	
	var marker = markers[current_marker]
	
	# Chekcing and assigning waypoint values
	if marker.get_script() != null:
		if marker.wait:
			waiting = true
			timer.start(marker.wait_time)
		
		if marker.change_speed:
			if marker.speed_value > 0:
				speed = marker.speed_value
			if marker.speed_multiplyer > 0:
				speed_multiplyer = marker.speed_multiplyer
		
		if marker.turn_towards:
			wait_turn_target = marker.turn_target.global_position
		else:
			wait_turn_target = global_position
		
		if marker.give_new_path:
			if not marker.random_new_path:
				positions_container = marker.new_paths[0]
			else:
				var new_path = randi_range(0, marker.new_paths.size() - 1)
				positions_container = marker.new_paths[new_path]
			
			_fill_waypoints()
			return
	
	# Deciding to loop a
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
	
	
	emit_signal("finished_path")


func _on_wait_timeout():
	waiting = false


## Turns the chracter towards target
func _turn(delta, target:Vector3):
	child_look_at.look_at(Vector3(target.x, child_look_at.global_position.y, target.z), Vector3.UP, true)
	var target_rotation = Quaternion(child_look_at.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_Speed)
	global_transform.basis = Basis(next_rotation)


## Refills markers from positions_container while setting current_marker to 0
func _fill_waypoints():
	current_marker = 0
	markers.clear()
	for marker in positions_container.get_children():
		if marker is Marker3D:
			markers.append(marker)
	
	nav_agent.target_position = markers[current_marker].global_position
