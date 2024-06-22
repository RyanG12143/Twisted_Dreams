extends Older_State
class_name Older_Idle

func Enter():
	movement_speed = 0

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	
	# Handle jump
	if Input.is_action_just_pressed("3Djump") and older_brother.is_on_floor():
		Transitioned.emit(self, "Older_Jump")
	
	# Handle falling
	if older_brother.velocity.y < 0 and not older_brother.is_on_floor():
		Transitioned.emit(self, "Older_Fall")
	
	if Input.is_action_pressed("3Dforward") || Input.is_action_pressed("3Dbackward") || Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		if Input.is_action_pressed("3Dsprint"):
			Transitioned.emit(self, "Older_Run")
		else:
			Transitioned.emit(self, "Older_Walk")
	
	var move_dir = direction.rotated(Vector3.UP, older_brother._camera.rotation.y).normalized()
	
	velocity_move = lerp(older_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	older_brother.velocity = velocity_move
	
func _process(delta):
	super(delta)

