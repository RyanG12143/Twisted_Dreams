extends Crate
class_name Luminous_Cr
## Moveable, weighted luminous crates.


var enemies:Array[CharacterBody2D] = []
var target_rays:Dictionary = {}



func _on_enemy_enter(body):
	if body.is_in_group("Enemy"):
		_add_ray(body)
		if _check_valid(body):
			body.flee(self)
		enemies.append(body)


func _on_enemy_exit(body):
	if body.is_in_group("Enemy"):
		if _check_valid(body):
			body.flee(self)
		enemies.erase(body)


func _on_timer_timeout():
	for enemy in enemies:
		if _check_valid(enemy):
			enemy.flee(self)


func _add_ray(body):
	if not target_rays.has(body):
		var ray:RayCast2D = RayCast2D.new()
		ray.set_collision_mask_value(4, true)
		ray.hit_from_inside = true
		add_child(ray)
		target_rays[body] = ray


func _check_valid(target):
	target_rays[target].target_position = target.global_position - target_rays[target].global_position
	target_rays[target].force_raycast_update()
	if target_rays[target].get_collider() == target:
		return true
	
	return false
