class_name Charge_Prep
extends Enemy_State

@export var prep_time:float = .5

var timer:Timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)


func enter(body:CharacterBody2D):
	timer.start(prep_time)


func update(body:CharacterBody2D, delta:float):
	if timer.is_stopped():
		if body.roaming:
			emit_signal("transitioned", self, "Charging")

