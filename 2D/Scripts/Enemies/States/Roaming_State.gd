class_name Roaming
extends Enemy_State


@export var ray_cast_down_right:RayCast2D
@export var ray_cast_side_right:RayCast2D
@export var ray_cast_down_left:RayCast2D
@export var ray_cast_side_left:RayCast2D

var roam_right:bool = true

func enter(body:CharacterBody2D):
	roam_right = body.is_facing_right


func physics_update(body:CharacterBody2D, delta:float):
	var direction:float = 1.0 if roam_right else -1.0
	
	body.velocity.x = direction * body.SPEED * delta


func update(body:CharacterBody2D, delta:float):
	if roam_right:
		if not ray_cast_down_right.is_colliding() or ray_cast_side_right.is_colliding():
			roam_right = false
	else:
		if not ray_cast_down_right.is_colliding() or ray_cast_side_right.is_colliding():
			roam_right = true
	
	
	if not body.targets:
		return
	
	for target in body.targets:
		body.target_rays[target].target_position = target.global_position - body.target_rays[target].global_position
		if body.target_rays[target].get_collider() == target:
			emit_signal("transitioned", self, "Follow")
			return
	
