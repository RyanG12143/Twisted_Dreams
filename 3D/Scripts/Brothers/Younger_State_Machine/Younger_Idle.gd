extends Younger_State
class_name Younger_Idle

func Enter():
	movement_speed = 0

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	
	# Handle jump
	if Input.is_action_just_pressed("3Djump") and younger_brother.is_on_floor():
		Transitioned.emit(self, "Younger_Jump")
	
	# Handle falling
	if younger_brother.velocity.y < 0 and not younger_brother.is_on_floor():
		Transitioned.emit(self, "Younger_Fall")
	
	if Input.is_action_pressed("3Dforward") || Input.is_action_pressed("3Dbackward") || Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		if Input.is_action_pressed("3Dsprint"):
			Transitioned.emit(self, "Younger_Run")
		else:
			Transitioned.emit(self, "Younger_Walk")
	
	var move_dir = direction.rotated(Vector3.UP, younger_brother._camera.rotation.y).normalized()
	
	velocity_move = lerp(younger_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	younger_brother.velocity = velocity_move
	
func _process(delta):
	super(delta)

