extends State
class_name WalkState
## Walk state of 2D characters.

func Enter():
	owner.anim.play("Walk")

func Exit():
	pass

func Update(delta):
	if !owner.is_grounded:
		if owner.velocity.y < 0:
			Transitioned.emit(self, "Jump")
		elif owner.velocity.y >= 200:
			Transitioned.emit(self, "Fall")
	elif (owner.velocity.x < 5 && owner.velocity.x >= 0 ) or (owner.velocity.x > -5 && owner.velocity.x <= 0):
		Transitioned.emit(self, "Idle")
		
		

func Physics_Update(delta):
	pass

func _input(event):
	pass
