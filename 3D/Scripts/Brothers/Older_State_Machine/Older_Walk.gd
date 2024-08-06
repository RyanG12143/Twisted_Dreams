extends Older_State
class_name Older_Walk

func Enter():
	movement_speed = walk_speed

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	
	# Handle falling
	if older_brother.velocity.y < 0 and not older_brother.is_on_floor():
		Transitioned.emit(self, "Older_Fall")
	
	# Handle jump.
	if Input.is_action_just_pressed("3Djump") and older_brother.is_on_floor():
		Transitioned.emit(self, "Older_Jump")
		
	
	direction = Vector3(Input.get_action_strength("3Dleft") - Input.get_action_strength("3Dright"), 0, Input.get_action_strength("3Dforward") - Input.get_action_strength("3Dbackward"))
	
	if Input.is_action_pressed("3Dforward") || Input.is_action_pressed("3Dbackward") || Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		if Input.is_action_pressed("3Dsprint"):
			Transitioned.emit(self, "Older_Run")
	else:
		Transitioned.emit(self, "Older_Idle")
	
	var move_dir = direction.rotated(Vector3.UP, older_brother._camera.rotation.y).normalized()
	
	velocity_move = lerp(older_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	older_brother.velocity = velocity_move
	
	# Turns the character towards the input direction
	rotation_helper.look_at(Vector3(-velocity_move.x, rotation_helper.global_position.y, -velocity_move.z), Vector3.UP, true)
	var target_rotation = Quaternion(rotation_helper.global_transform.basis)
	var current_rotation = Quaternion(older_brother.global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_speed)
	
	older_brother.global_transform.basis = Basis(next_rotation)
	

func _process(delta):
	super(delta)

