class_name Fleeing
extends Enemy_State


@export var flee_time:float = .5
@export var flee_multiplyer:float = 2
@export var ray_cast_down_right:RayCast2D
@export var ray_cast_side_right:RayCast2D
@export var ray_cast_down_left:RayCast2D
@export var ray_cast_side_left:RayCast2D

var flee_right:bool
var timer:Timer
var flee_object:PhysicsBody2D


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)


func enter(body:CharacterBody2D):
	body.set_collision_mask_value(2, false)
	
	var direction = body.global_position.direction_to(flee_object.global_position)
	flee_right = true if direction.x < 0 else false
	timer.start(flee_time)


func exit(body:CharacterBody2D):
	body.set_collision_mask_value(2, true)


func physics_update(body:CharacterBody2D, delta:float):
	var direction = 1 if flee_right else -1
	
	body.velocity.x = direction * body.SPEED * delta * flee_multiplyer
	
	if body.grounded:
		if body.velocity.x > 0:
			if not ray_cast_down_right.is_colliding() or ray_cast_side_right.is_colliding():
				flee_right = not flee_right
		else:
			if not ray_cast_down_left.is_colliding() or ray_cast_side_left.is_colliding():
				flee_right = not flee_right


func update(body:CharacterBody2D, delta:float):
	if timer.is_stopped():
		if body.roaming:
			emit_signal("transitioned", self, "Roaming")
		else:
			emit_signal("transitioned", self, "Idle")


func reset():
	timer.start(flee_time)

