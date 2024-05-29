extends Sprite2D

@export var distance: Vector2 = Vector2(0, 100)
@export var duration: float = 5.0
var start_pos: Vector2
var objects: int = 0
signal object_on
signal object_off

func start_movement():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($Platform2Body, "position", distance * objects, duration / 2)

func backwards_movement():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($Platform2Body, "position", -(distance * objects), duration / 2)


func _on_area_2d_body_entered(body):
	++objects
	start_movement()
	object_on.emit()

func _on_area_2d_body_exited(body):
	--objects
	backwards_movement()
	object_off.emit()
