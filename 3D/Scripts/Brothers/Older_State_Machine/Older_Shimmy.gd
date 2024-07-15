extends Older_State
class_name Older_Shimmy

func Enter():
	enable_gravity = false
	older_brother.velocity = Vector3.ZERO

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	
	if Input.is_action_pressed("3Djump") and can_climb():
		Transitioned.emit(self, "Older_Climb")
		
	if Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		direction = Vector3(Input.get_action_strength("3Dleft") - Input.get_action_strength("3Dright"), 0, 0)
	else:
		Transitioned.emit(self, "Older_Hang")
	
	if not player_normal.is_colliding():
		Transitioned.emit(self, "Older_Fall")
	
	
	# Movement with wall normal
	var rot = -(atan2(player_normal.get_collision_normal().z, player_normal.get_collision_normal().x) - PI/2)
	var f_input = Input.get_action_strength("3Dforward") - Input.get_action_strength("3Dbackward")
	var h_input =  Input.get_action_strength("3Dleft") - Input.get_action_strength("3Dright")
	direction = Vector3(h_input, f_input, 0).rotated(Vector3.UP, rot).normalized()
	
	# Facing wall normal
	older_brother.rotation.y = -(atan2(player_normal.get_collision_normal().z, player_normal.get_collision_normal().x) - PI/2)
	
	var move_dir = direction
	
	velocity_move = lerp(older_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	older_brother.velocity = velocity_move
	
	

func _process(delta):
	super(delta)
	
	# Facing wall normal
	#if direction != Vector3.ZERO and !is_shimmy:
		#mesh.rotation.y = lerp.angle(mesh.rotation.y, atan2(-direciton.x, -direction.z), angular_velocity * delta)
	# was elif
	#if direction != Vector3.ZERO:
	#mesh.rotation.y = -(atan2(player_normal.get_collision_normal().z, player_normal.get_collision_normal().x) - PI/2)
