extends State
class_name WalkState
## Walk state of 2D characters.

func Enter():
	parent.anim.play("Walk")

func Exit():
	pass

func Update(delta):
	if !parent.is_grounded:
		if parent.velocity.y < 0:
			Transitioned.emit(self, "Jump")
		elif parent.velocity.y >= 200:
			Transitioned.emit(self, "Fall")
	elif (parent.velocity.x < 5 && parent.velocity.x >= 0 ) or (parent.velocity.x > -5 && parent.velocity.x <= 0):
		Transitioned.emit(self, "Idle")
		
		

func Physics_Update(delta):
	pass

func _input(event):
	pass
