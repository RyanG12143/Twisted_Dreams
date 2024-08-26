class_name NPC
extends CharacterBody3D

## Emitted when NPC has no more positions to path towards
signal finished_path

## Movement speed of NPC
@export var speed = 5.0
## Turn speed of NPC
@export var turn_Speed:float = 20
## IF true NPC will look at Observable Characters/NPC's in radius
@export var observe:bool = false
## Head to turn towards observable Character/NPC
@export var head:MeshInstance3D
## If true NPC will travel in loop through each waypoint
@export var loop:bool = false
## If true npc will backtrack through waypoints. (1234321)[br][br]
## MUST HAVE LOOP ENABLED
@export var inverse_loop:bool = false
## If true npc queue_free() will be called on node after path is travelled
@export var free_on_end:bool = false
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
## If true will get next position after waiting
var wait_update:bool = true
## Target to turn towards when reaching waypoint
var wait_turn_target:Vector3 = Vector3.ZERO
## Array full of targets to observe
var observe_targets:Array[Node3D] = []
## Current target to turn head towards
var observe_target:Node3D
## Cache on level
var npc_cache:Node


## Navigation agent to provide pathfinding for npc
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
## Timer to set wait time
@onready var wait_timer:Timer = $Wait_Timer
## Marker to enable correct desired rotation
@onready var rotation_helper:Marker3D = Marker3D.new()



func _ready():
	if %NPC_Cache and not npc_cache:
		npc_cache = %NPC_Cache
	
	if observe:
		$Update_Timer.start(.1)
	
	if not rotation_helper.is_inside_tree():
		add_child(rotation_helper)
	# Disable processing if not given path to follow (Easier to debug)
	if not positions_container:
		return
	_fill_waypoints()


func ready():
	if observe:
		$Update_Timer.start(.1)
	else:
		$Update_Timer.stop()
	_fill_waypoints()
	current_marker = 0
	traverse_direction = 1


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	_head_logic(delta)
	
	# Catch no position_container
	if not positions_container:
		move_and_slide()
		return
	
	# Waiting at waypoint
	if waiting:
		_turn(delta, wait_turn_target)
		move_and_slide()
		return
	
	if nav_agent.target_position != markers[current_marker].global_position:
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
	
	var targ_pos = nav_agent.target_position
	targ_pos.y = global_position.y
	var dist_targ = global_position.distance_to(targ_pos)
	
	# Checking if reached target without height
	if dist_targ < nav_agent.target_desired_distance:
		nav_agent.emit_signal("target_reached")


func _head_logic(delta):
	if head:
		if observe_target and observe:
			_head_turn_clamp(delta, observe_target.global_position, 90)
		elif observe and not positions_container:
			var point = $Front.global_position
			point.y = head.global_position.y
			_head_turn_clamp(delta, point, 90)
		else:
			var path = nav_agent.get_current_navigation_path()
			if path.size() > 0:
				var path_index = nav_agent.get_current_navigation_path_index()
				var point
				if path_index + 1 < path.size():
					point = path[path_index + 1]
				else:
					point = path[path_index]
				point.y = head.global_position.y
				_head_turn_clamp(delta, point, 90)
			else:
				_head_turn_clamp(delta, nav_agent.get_next_path_position(), 90)


func _process(delta):
	pass


func _on_target_reached():
	if not markers:
		return
	var marker = markers[current_marker]
	
	# Chekcing and assigning waypoint values
	if marker.get_script() != null:
		
		if marker.turn_towards:
			wait_turn_target = marker.turn_target.global_position
		else:
			wait_turn_target = global_position
		
		if marker.wait and not waiting:
			marker.empty = false
			waiting = true
			wait_timer.start(marker.wait_time)
			return
		
		if marker.queue:
			if not markers[current_marker + 1].empty:
				markers[current_marker + 1].waypoint_freed.connect(_next_queue_empty)
				waiting = true
				marker.empty = false
				return
		
		marker.emptied()
		
		if marker.change_speed:
			if marker.speed_value > 0:
				speed = marker.speed_value
			if marker.speed_multiplyer > 0:
				speed_multiplyer = marker.speed_multiplyer
		
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
	
	elif loop and inverse_loop:
		traverse_direction *= -1
		current_marker += 1 * traverse_direction
		nav_agent.target_position = markers[current_marker].global_position
	
	elif loop:
		current_marker = 0
		nav_agent.target_position = markers[current_marker].global_position
	
	else:
		emit_signal("finished_path")
		if free_on_end:
			despawn()
	
	if markers[current_marker].get_script() != null:
		markers[current_marker].empty = false


## Turns the chracter towards target
func _turn(delta, target:Vector3):
	rotation_helper.look_at(Vector3(target.x, rotation_helper.global_position.y, target.z), Vector3.UP, true)
	var target_rotation = Quaternion(rotation_helper.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_Speed)
	
	global_transform.basis = Basis(next_rotation)

## Turns the chracter head towards target
func _head_turn_clamp(delta, target:Vector3, clamp:float):
	
	var new_transform = head.global_transform.looking_at(target, Vector3.UP, true)
	head.global_transform = head.global_transform.interpolate_with(new_transform, delta * 5)
	head.rotation_degrees.y = clampf(head.rotation_degrees.y, -clamp, clamp)
	
	head.scale = Vector3(1,1,1) # Scale gets weird with global transforms so this puts it back to normal


## Refills markers from positions_container while setting current_marker to 0
func _fill_waypoints():
	current_marker = 0
	markers.clear()
	for marker in positions_container.get_children():
		if marker is Marker3D:
			markers.append(marker)
	
	nav_agent.target_position = markers[current_marker].global_position


func _on_update_timeout():
	var ray:RayCast3D = $Observe_Ray
	var valid_targets = []
	for body in observe_targets:
		ray.target_position = body.global_position - global_position
		ray.force_raycast_update()
		if ray.get_collider() == body or ray.get_collider() == null:
			valid_targets.append(body)
	
	if not valid_targets:
		observe_target = null
		return
	
	observe_target = valid_targets[0]
	
	for body in valid_targets:
		if global_position.distance_to(body.global_position) < global_position.distance_to(observe_target.global_position):
			observe_target = body

func _on_observe_area_entered(body):
	if body.is_in_group("Observable"):
		observe_targets.append(body)


func _on_observe_area_body_exited(body):
	if body.is_in_group("Observable"):
		observe_targets.erase(body)


func _on_wait_timeout():
	if wait_update:
		_on_target_reached()
	else:
		wait_update = true
	waiting = false


func _next_queue_empty():
	markers[current_marker + 1].waypoint_freed.disconnect(_next_queue_empty)
	_on_target_reached()
	waiting = false



func wait(time:float):
	wait_update = false
	waiting = true
	wait_timer.start(time)


func despawn():
	if npc_cache:
		print("Despawn")
		npc_cache.despawn_pathing_npc(self)
	else:
		print("free")
		queue_free()
