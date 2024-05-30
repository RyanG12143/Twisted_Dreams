class_name Pulley
extends Node2D

@export var distance: Vector2 = Vector2(0, -100)
@export var duration: float = 5.0
var start_pos: Vector2

signal object_on
signal object_off

func start_movement():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($Platform1Body, "position", -(distance), duration / 2)
	print("Going down")

func backwards_movement():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($Platform1Body, "position", distance, duration / 2)
	print("Going up")

func _on_area_2d_body_entered(body):
	start_movement()
	object_on.emit()

func _on_area_2d_body_exited(body):
	backwards_movement()
	object_off.emit()

func _on_pulley_platform_object_on():
	backwards_movement()
