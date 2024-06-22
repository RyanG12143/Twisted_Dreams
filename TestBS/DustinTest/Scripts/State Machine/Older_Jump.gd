extends Older_State
class_name Older_Jump

func Enter():
	older_brother.velocity.y = JUMP_VELOCITY

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

func _process(delta):
	super(delta)
	if Input.is_action_pressed("3Djump") and can_climb():
		Transitioned.emit(self, "Older_Grab")

