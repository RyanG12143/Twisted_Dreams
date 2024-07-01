extends State
class_name FallState
## Fall state of 2D characters.

func Enter():
	owner.anim.play("Fall")

func Exit():
	pass

func Update(delta):
	if owner.is_grounded:
		Transitioned.emit(self, "Land")
	elif owner.velocity.y < 0:
			Transitioned.emit(self, "Jump")
		
		

func Physics_Update(delta):
	pass

func _input(event):
	pass
