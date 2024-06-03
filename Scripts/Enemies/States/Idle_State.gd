extends Enemy_State
class_name Idle

@export var range:float = 100

func enter(body:CharacterBody2D):
	pass


func exit(body:CharacterBody2D):
	pass


func physics_update(body:CharacterBody2D, delta:float):
	pass


func update(body:CharacterBody2D, delta:float):
	if not body.target:
		return
	if body.global_position.distance_to(body.target.global_position) < range:
		emit_signal("transitioned", self, "Follow")
		return
