extends Crate
class_name Luminous_Cr
## Moveable, weighted luminous crates.

const MIN_LIGHT:float = 1.4

const MAX_LIGHT:float = 1.7

const LIGHT_CHANGE_AMOUNT = 0.0005

@onready var sprite:Sprite2D = $Sprite2D

var enemies:Array[CharacterBody2D] = []
var target_rays:Dictionary = {}

var glow_increasing:bool = true

func _ready():
	sprite.self_modulate.r = MIN_LIGHT
	sprite.self_modulate.g = MIN_LIGHT
	sprite.self_modulate.b = MIN_LIGHT

func _process(delta):
	print(sprite.self_modulate.r)
	if(sprite.self_modulate.r < MAX_LIGHT and glow_increasing):
		sprite.self_modulate.r += LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.g += LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.b += LIGHT_CHANGE_AMOUNT
	elif(sprite.self_modulate.r >= MAX_LIGHT and glow_increasing):
		glow_increasing = false
		
	if (sprite.self_modulate.r > MIN_LIGHT and !glow_increasing):
		sprite.self_modulate.r -= LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.g -= LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.b -= LIGHT_CHANGE_AMOUNT
	elif(sprite.self_modulate.r <= MIN_LIGHT and !glow_increasing):
		glow_increasing = true
	

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
