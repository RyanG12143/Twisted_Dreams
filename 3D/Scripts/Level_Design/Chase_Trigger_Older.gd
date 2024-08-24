extends Node3D

@export var player: CharacterBody3D
@export var collider: Area3D
@export var chasing_officer: CharacterBody3D
var event_triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	chasing_officer.waiting = true

func _on_chase_trigger_body_entered(body):
	if body.is_in_group("Player"):
		chasing_officer.waiting = false
		event_triggered = true
