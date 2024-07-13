class_name Weeping
extends Enemy_State


func enter(body:CharacterBody2D):
	body.velocity = Vector2(0,0)
	
	body.anim.play("idle")
	body.anim.stop()


func update(body:CharacterBody2D, delta:float):
	if not body.targets:
		if body.roaming:
			emit_signal("transitioned", self, "Roaming")
		else:
			emit_signal("transitioned", self, "Idle")
		return
	
	var looked_at:bool = false
	
	for target in body.targets:
		body.target_rays[target].target_position = target.global_position - body.target_rays[target].global_position
		body.target_rays[target].force_raycast_update()
		if body.target_rays[target].get_collider() == target:
			var direction:Vector2 = body.global_position.direction_to(target.global_position)
			
			if direction.x > 0 and not target.is_facing_right:
				looked_at = true
			elif direction.x < 0 and target.is_facing_right:
				looked_at = true
	
	if not looked_at:
		emit_signal("transitioned", self, "Follow")
