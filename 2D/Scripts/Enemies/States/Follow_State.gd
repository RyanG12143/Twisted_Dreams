class_name Follow
extends Enemy_State

@export var ray_cast_down_right:RayCast2D
@export var ray_cast_down_left:RayCast2D


func enter(body:CharacterBody2D):
	body.anim.play("walk")


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
	
	var valid_targets:Array[CharacterBody2D] = []
	
	for target in body.targets:
		body.target_rays[target].target_position = target.global_position - body.target_rays[target].global_position
		body.target_rays[target].force_raycast_update()
		if body.target_rays[target].get_collider() == target:
			valid_targets.append(target)
	
	if not valid_targets:
		if body.roaming:
			emit_signal("transitioned", self, "Roaming")
		else:
			emit_signal("transitioned", self, "Idle")
		return
	
	body.target = valid_targets[0]
	if valid_targets.size() > 1:
		for target in valid_targets:
			var body_dist_target = body.global_position.distance_to(target.global_position)
			var body_dist_curr_target = body.global_position.distance_to(body.target.global_position)
			
			if body_dist_target < body_dist_curr_target:
				body.target = target
	
	if body.charging:
		var charge_radius:Area2D = body.get_node("Charge_Radius")
		
		if charge_radius.get_overlapping_bodies().has(body.target):
			emit_signal("transitioned", self, "Charge_Prep")
	
	if body.weeping:
		
		for target in body.targets:
			body.target_rays[target].target_position = target.global_position - body.target_rays[target].global_position
			if body.target_rays[target].get_collider() == target:
				var direction:Vector2 = body.global_position.direction_to(target.global_position)
				
				if direction.x > 0 and not target.is_facing_right:
					emit_signal("transitioned", self, "Weeping")
				elif direction.x < 0 and target.is_facing_right:
					emit_signal("transitioned", self, "Weeping")
