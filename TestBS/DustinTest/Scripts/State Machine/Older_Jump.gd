extends Older_State
class_name Older_Jump

func Enter():
	older_brother.velocity.y = JUMP_VELOCITY

func Update(delta: float):
	pass

func Physics_Update(_delta: float):
	pass
	
	#if INSERT STATE CHANGE CONDITION HERE:
		#Transitioned.emit(self, "Run")

func _process(delta):
	pass

