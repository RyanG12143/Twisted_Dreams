extends Older_State
class_name Older_Jump

func Enter():
	#movement_speed = strafe_speed
	older_brother.velocity.y = JUMP_VELOCITY
	acceleration = 1
	if animation_tree:
		animation_tree.travel("OlderBrother_Jump")

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	if older_brother.velocity.y < 0:
		Transitioned.emit(self, "Older_Fall")
	
	if older_brother.is_on_floor():
		if Input.is_action_pressed("3Dforward") || Input.is_action_pressed("3Dbackward") || Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
			if Input.is_action_pressed("3Dsprint"):
				Transitioned.emit(self, "Older_Run")
			else:
				Transitioned.emit(self, "Older_Walk")
		else:
			Transitioned.emit(self, "Older_Idle")
	
	direction = Vector3(Input.get_action_strength("3Dleft") - Input.get_action_strength("3Dright"), 0, Input.get_action_strength("3Dforward") - Input.get_action_strength("3Dbackward"))
	
	var move_dir = direction.rotated(Vector3.UP, older_brother._camera.rotation.y).normalized()
	
	velocity_move = lerp(older_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	older_brother.velocity.x = velocity_move.x
	older_brother.velocity.z = velocity_move.z
	
	# Turns the character towards the input direction
	rotation_helper.look_at(Vector3(-velocity_move.x, rotation_helper.global_position.y, -velocity_move.z), Vector3.UP, true)
	var target_rotation = Quaternion(rotation_helper.global_transform.basis)
	var current_rotation = Quaternion(older_brother.global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * turn_speed)
	
	older_brother.global_transform.basis = Basis(next_rotation)

func _process(delta):
	super(delta)
	if Input.is_action_pressed("3Djump") and can_grab():
		Transitioned.emit(self, "Older_Grab")

