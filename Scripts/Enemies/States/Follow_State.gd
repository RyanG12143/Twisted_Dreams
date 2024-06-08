class_name Follow
extends Enemy_State

@export var range:float = 100
@export var ray_cast_down_right:RayCast2D
@export var ray_cast_down_left:RayCast2D


func physics_update(body:CharacterBody2D, delta:float):
	if not body.target:
		return
	
	var direction:Vector2 = body.global_position.direction_to(body.target.global_position)
	
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
	if not body.targets:
		if body.roaming:
			emit_signal("transitioned", self, "Roaming")
		else:
			emit_signal("transitioned", self, "Idle")
		return
