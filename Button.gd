extends Sprite2D

signal active

func _on_area_2d_body_entered(body : Node):
	active.emit()
	print("activate")
