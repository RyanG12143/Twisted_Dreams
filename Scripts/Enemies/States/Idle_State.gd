class_name Idle
extends Enemy_State


@export var range:float = 100


func update(body:CharacterBody2D, delta:float):
	if not body.target:
		return
	if body.global_position.distance_to(body.target.global_position) < range:
		emit_signal("transitioned", self, "Follow")
		return
