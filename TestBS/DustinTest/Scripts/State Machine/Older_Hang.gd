extends Older_State
class_name Older_Hang

func Enter():
	enable_gravity = false
	

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	older_brother.velocity = Vector3.ZERO
	if Input.is_action_pressed("3Djump")  and can_climb():
		Transitioned.emit(self, "Older_Climb")
		
	if Input.is_action_pressed("3Drelease"):
		enable_gravity = true
		Transitioned.emit(self, "Older_Fall")
		
	if Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		Transitioned.emit(self, "Older_Shimmy")

	
	

func _process(delta):
	super(delta)
