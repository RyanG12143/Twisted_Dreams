extends CharacterBody2D
class_name Crate

var gravity = 20
var reset_position
const SLIDE_TIME = 1.0

func _ready():
	reset_position = position
	

func _physics_process(delta):
	velocity.y += gravity
	move_and_slide()
	
	
	if(abs(velocity.x) >= 3.0):
		if(velocity.x > 0.0):
			slide(Vector2(velocity.x - 3.0, velocity.y))
		else:
			slide(Vector2(velocity.x + 3.0, velocity.y))
	else:
		velocity.x = 0.0
		
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider() is Crate:
			collision.get_collider().slide(Vector2(velocity.x, 0))
		
	

func _process(delta):
	if(Input.is_action_pressed("ui_crate_reset")):
		position = reset_position

func slide(vector):
	velocity.x = vector.x
	
