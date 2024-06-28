class_name Idle
extends Enemy_State


func update(body:CharacterBody2D, delta:float):
	if not body.targets:
		return
	
	for target in body.targets:
		body.target_rays[target].target_position = target.global_position - body.target_rays[target].global_position
		if body.target_rays[target].get_collider() == target:
			emit_signal("transitioned", self, "Follow")
