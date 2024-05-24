extends CharacterBody2D
class_name Crate

var gravity = 200

func _physics_process(delta):
	velocity.y += gravity
	move_and_slide()
	velocity = Vector2.ZERO
	
func _slide(vector):
	velocity.x = vector.x
	
