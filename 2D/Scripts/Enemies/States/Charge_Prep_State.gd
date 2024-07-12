class_name Charge_Prep
extends Enemy_State

@export var prep_time:float = .5

var timer:Timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)


func enter(body:CharacterBody2D):
	var target_right = 
	if body.is_facing_right and velocity.x < 0:
		body.is_facing_right = false
		body.anim.flip_h = true
	elif not body.is_facing_right and velocity.x > 0:
		body.is_facing_right = true
		body.anim.flip_h = false
	timer.start(prep_time)
	
	body.anim.play("idle")


func update(body:CharacterBody2D, delta:float):
	if timer.is_stopped():
		if body.roaming:
			emit_signal("transitioned", self, "Charging")

