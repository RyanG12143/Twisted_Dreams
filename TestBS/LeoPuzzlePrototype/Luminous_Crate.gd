extends Crate
class_name Luminous_Cr
## Moveable, weighted luminous crates.


var enemies:Array[CharacterBody2D] = []


func _on_enemy_enter(body):
	if body.is_in_group("Enemy"):
		body.flee(self)
		enemies.append(body)


func _on_enemy_exit(body):
	if body.is_in_group("Enemy"):
		body.flee(self)
		enemies.erase(body)


func _on_timer_timeout():
	for enemy in enemies:
		enemy.flee(self)
