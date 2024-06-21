extends Older_State
class_name Older_Idle

func Enter():
	movement_speed = 0

func Update(delta: float):
	pass


func Physics_Update(_delta: float):
	# Handle jump.
	if Input.is_action_just_pressed("3Djump") and older_brother.is_on_floor():
		Transitioned.emit(self, "Older_Jump")
	
	if Input.is_action_pressed("3Dforward") || Input.is_action_pressed("3Dbackward") || Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		if Input.is_action_pressed("3Dsprint"):
			Transitioned.emit(self, "Older_Run")
		else:
			Transitioned.emit(self, "Older_Walk")

func _process(delta):
	pass

