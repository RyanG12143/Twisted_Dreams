class_name Charge_Prep
extends Enemy_State

@export var prep_time:float = .5

var timer:Timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)


func enter(body:CharacterBody2D):
	var dir_target = body.global_position.direction_to(body.target.global_position)
	var target_right = true if dir_target.x > 0 else false
	
	if body.is_facing_right and not target_right:
		body.is_facing_right = false
		body.anim.flip_h = true
	elif not body.is_facing_right and target_right:
		body.is_facing_right = true
		body.anim.flip_h = false
	
	timer.start(prep_time)
	
	body.anim.play("idle")


func update(body:CharacterBody2D, delta:float):
	if timer.is_stopped():
		emit_signal("transitioned", self, "Charging")

