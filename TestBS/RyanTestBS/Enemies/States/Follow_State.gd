extends Enemy_State
class_name Follow

@export var range:float = 100

func enter():
	pass


func exit():
	pass


func physics_update(body:CharacterBody2D, delta:float):
	var direction:Vector2 = (body.nav.get_next_path_position() - body.global_position).normalized()
	
	direction.x = 1 if direction.x > 0 else -1
	
	body.velocity.x = direction.x * body.SPEED * delta


func update(body:CharacterBody2D):
	if not body.target:
		return
	if body.global_position.distance_to(body.target.global_position) > range:
		emit_signal("transitioned", self, "Idle")
