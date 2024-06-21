extends Older_State
class_name Older_Fall

func Enter():
	pass

func Update(delta: float):
	pass

func Physics_Update(_delta: float):
	pass
	

	#if INSERT STATE CHANGE CONDITION HERE:
		#Transitioned.emit(self, "Run")

func _process(delta):
	if Input.is_action_pressed("3Djump") and can_climb():
		Transitioned.emit(self, "Older_Grab")


