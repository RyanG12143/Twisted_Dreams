extends Sprite2D

@export var distance: float = 50.0
var start_pos: Vector2
var objects: int = 0
var t: float = 0.0

signal object_on
signal object_off

func _ready():
	start_pos = position

func _process(delta):
	t += delta * 0.4
	if objects > 0:
		position = position.lerp(Vector2(position.x, start_pos.y + distance), t)
	if objects < 0:
		position = position.lerp(Vector2(position.x, start_pos.y - distance), t)
	if objects == 0 and position != start_pos:
		position = position.lerp(Vector2(position.x, start_pos.y), t)

#func start_movement():
	#pass
#
#func backwards_movement():
	#
	#print("Going up")

func _on_area_2d_body_entered(body):
	if not body.is_in_group("Pulley_Platform"):
		objects += 1
		print("Going down")
		object_on.emit()


func _on_area_2d_body_exited(body):
	if not body.is_in_group("Pulley_Platform"):
		objects -= 1
		print("Going up")
		object_off.emit()
