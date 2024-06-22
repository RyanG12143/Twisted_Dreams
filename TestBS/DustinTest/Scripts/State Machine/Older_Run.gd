extends Older_State
class_name Older_Run

func Enter():
	movement_speed = run_speed

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
	
	# setting the look direction
	var testVelocity: Vector3 = Vector3(older_brother.velocity.x, 0, older_brother.velocity.z)
	if testVelocity.length() > 0.2 and !chest_ray.is_colliding() and can_turn:
		var look_direction: Vector2 = -Vector2(older_brother.velocity.z, older_brother.velocity.x)
		older_brother._player_direction.rotation.y = look_direction.angle()
	
	direction = Vector3(Input.get_action_strength("3Dleft") - Input.get_action_strength("3Dright"), 0, Input.get_action_strength("3Dforward") - Input.get_action_strength("3Dbackward"))
	
	if Input.is_action_pressed("3Dforward") || Input.is_action_pressed("3Dbackward") || Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		if !Input.is_action_pressed("3Dsprint"):
			Transitioned.emit(self, "Older_Walk")
	else:
		Transitioned.emit(self, "Older_Idle")
	
	var move_dir = direction.rotated(Vector3.UP, older_brother._camera.rotation.y).normalized()
	
	velocity_move = lerp(older_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	older_brother.velocity = velocity_move

func _process(delta):
	super(delta)
