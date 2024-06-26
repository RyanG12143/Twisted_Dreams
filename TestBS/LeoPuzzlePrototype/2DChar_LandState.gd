extends State
class_name LandState
## Landstate of 2D characters.

func Enter():
	parent.anim.play("Land")
	await get_tree().create_timer(0.15).timeout
	Transitioned.emit(self, "Idle")

func Exit():
	pass

func Update(delta):
	pass

func Physics_Update(delta):
	pass

func _input(event):
	pass
