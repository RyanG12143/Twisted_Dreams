extends Older_State
class_name Older_Grab

func Enter():
	await get_tree().create_timer(2.0).timeout
	Transitioned.emit(self, "Older_Hang")

func Update(delta: float):
	pass

func Physics_Update(_delta: float):
	pass
	

	#if INSERT STATE CHANGE CONDITION HERE:
		#Transitioned.emit(self, "Run")

func _process(delta):
	pass
