extends State
class_name JumpState
## Jump state of 2D characters.

func Enter():
	owner.anim.play("Jump")

func Exit():
	pass

func Update(delta):
	if owner.is_grounded:
		Transitioned.emit(self, "Land")
	elif owner.velocity.y >= 200:
		Transitioned.emit(self, "Fall")

func Physics_Update(delta):
	pass

func _input(event):
	pass
