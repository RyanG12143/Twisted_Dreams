extends Older_State
class_name Older_Hang

func Enter():
	older_brother.velocity = Vector3.ZERO
	older_brother.axis_lock_linear_y = true
	enable_gravity = false
	can_turn = false

func Update(delta: float):
	pass

func Physics_Update(_delta: float):
	if Input.is_action_pressed("3Djump"):
		Transitioned.emit(self, "Older_Climb")
	if Input.is_action_pressed("3Drelease"):
		enable_gravity = true
		can_turn = true
		called_grab = false
		Transitioned.emit(self, "Older_Fall")

func _process(delta):
	pass
