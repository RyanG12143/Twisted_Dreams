class_name Pulley
extends Node2D

@export var distance: float = 1.0
@export var duration: float = 5.0
var start_pos: Vector2

signal object_on
signal object_off

func start_movement():
	position.y += distance
	print("Going down")

func backwards_movement():
	position.y -= distance
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
