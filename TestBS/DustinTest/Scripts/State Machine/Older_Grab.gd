extends Older_State
class_name Older_Grab

func Enter():
	enable_gravity = false
	older_brother.velocity = Vector3.ZERO
	await get_tree().create_timer(1.0).timeout
	Transitioned.emit(self, "Older_Hang")

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	
	

	#if INSERT STATE CHANGE CONDITION HERE:
		#Transitioned.emit(self, "Run")

func _process(delta):
	super(delta)
