extends Node3D

@export var player: CharacterBody3D
@export var collider: Area3D
@export var chasing_officer: CharacterBody3D
var event_triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	chasing_officer.waiting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_chase_trigger_body_entered(body):
	chasing_officer.waiting = false
	event_triggered = true
