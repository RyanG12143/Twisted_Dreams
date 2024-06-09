class_name Charging
extends Enemy_State

@export var charge_multiplyer:float = 8
@export var ray_cast_down_right:RayCast2D
@export var ray_cast_down_left:RayCast2D

var charge_right:bool
var timer:Timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)


func enter(body:CharacterBody2D):
	body.velocity.x = 0
	charge_right = body.is_facing_right
	timer.start(1)


func physics_update(body:CharacterBody2D, delta:float):
	var direction = 1 if charge_right else -1
	
	body.velocity.x = direction * body.SPEED * delta * charge_multiplyer
	
	if body.grounded:
		if body.velocity.x > 0:
			if not ray_cast_down_right.is_colliding():
				body.velocity.x = 0
				timer.stop()
		else:
			if not ray_cast_down_left.is_colliding():
				body.velocity.x = 0
				timer.stop()


func update(body:CharacterBody2D, delta:float):
	if timer.is_stopped():
		if body.roaming:
			emit_signal("transitioned", self, "Roaming")
		else:
			emit_signal("transitioned", self, "Idle")

