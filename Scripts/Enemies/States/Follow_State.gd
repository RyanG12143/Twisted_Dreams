class_name Follow
extends Enemy_State

@export var range:float = 100
@export var ray_cast_down_right:RayCast2D
@export var ray_cast_down_left:RayCast2D


func physics_update(body:CharacterBody2D, delta:float):
	var direction:Vector2 = (body.nav.get_next_path_position() - body.global_position).normalized()
	
	direction.x = 1 if direction.x > 0 else -1
	
	body.velocity.x = direction.x * body.SPEED * delta
	if body.grounded:
		if body.velocity.x > 0:
			if not ray_cast_down_right.is_colliding():
				body.velocity.x = 0
		else:
			if not ray_cast_down_left.is_colliding():
				body.velocity.x = 0


func update(body:CharacterBody2D, delta:float):
	if not body.target:
		return
	if body.global_position.distance_to(body.target.global_position) > range:
		if body.roaming:
			emit_signal("transitioned", self, "Roaming")
		else:
			emit_signal("transitioned", self, "Idle")
		return
