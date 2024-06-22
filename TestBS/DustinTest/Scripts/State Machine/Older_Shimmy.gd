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

	var move_dir = direction
	
	velocity_move = lerp(older_brother.velocity, -move_dir * movement_speed, delta * acceleration)
	
	older_brother.velocity = velocity_move

func _process(delta):
	super(delta)
