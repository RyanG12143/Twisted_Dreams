class_name Roaming
extends Enemy_State


@export var range:float = 100
@export var ray_cast_down_right:RayCast2D
@export var ray_cast_side_right:RayCast2D
@export var ray_cast_down_left:RayCast2D
@export var ray_cast_side_left:RayCast2D

var roam_right:bool = true

func enter(body:CharacterBody2D):
	roam_right = true if body.velocity.x > 0 else false


func exit(body:CharacterBody2D):
	pass


func physics_update(body:CharacterBody2D, delta:float):
	var direction:float = 1.0 if roam_right else -1.0
	
	body.velocity.x = direction * body.SPEED * delta


func update(body:CharacterBody2D, delta:float):
	if roam_right:
		if not ray_cast_down_right.is_colliding() or ray_cast_side_right.is_colliding():
			roam_right = not roam_right
	else:
		if not ray_cast_down_left.is_colliding() or ray_cast_side_left.is_colliding():
			roam_right = not roam_right
	
	
	if not body.target:
		return
	if body.global_position.distance_to(body.target.global_position) < range:
		emit_signal("transitioned", self, "Follow")
		return
	
