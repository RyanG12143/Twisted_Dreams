extends State
class_name IdleState
## Idle state of 2D characters.

func Enter():
	owner.anim.play("Idle")

func Exit():
	pass

func Update(delta):
	if !owner.is_grounded:
		if owner.velocity.y < 0:
			Transitioned.emit(self, "Jump")
		elif owner.velocity.y >= 200:
			Transitioned.emit(self, "Fall")
	elif (owner.velocity.x >= 5) or (owner.velocity.x <= -5):
		Transitioned.emit(self, "Walk")
		
		

func Physics_Update(delta):
	pass

func _input(event):
	pass
