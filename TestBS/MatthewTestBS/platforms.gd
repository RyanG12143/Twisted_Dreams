class_name Pulley
extends Sprite2D

@export var distance: float = 20.0
var start_pos: Vector2

signal object_on
signal object_off

func start_movement():
	position = position.lerp(Vector2(position.x, position.y + distance), 1)
	print("Going down")

func backwards_movement():
	
	print("Going up")

func _on_area_2d_body_entered(body):
	start_movement()
	object_on.emit()

func _on_area_2d_body_exited(body):
	backwards_movement()
	object_off.emit()

func _on_pulley_platform_object_on():
	backwards_movement()

func _on_pulley_platform_object_off():
	start_movement()
