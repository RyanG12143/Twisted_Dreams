extends Younger_State
class_name Younger_Hang

func Enter():
	enable_gravity = false
	

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	younger_brother.velocity = Vector3.ZERO
	if Input.is_action_pressed("3Djump")  and can_climb():
		Transitioned.emit(self, "Younger_Climb")
		
	if Input.is_action_pressed("3Drelease"):
		enable_gravity = true
		Transitioned.emit(self, "Younger_Fall")
		
	if Input.is_action_pressed("3Dleft") || Input.is_action_pressed("3Dright"):
		Transitioned.emit(self, "Younger_Shimmy")
		
	if younger_brother.is_on_floor():
		Transitioned.emit(self, "Younger_Fall")

	
	

func _process(delta):
	super(delta)
