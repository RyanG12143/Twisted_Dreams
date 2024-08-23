extends Node3D

@export var player: CharacterBody3D
@export var collider: Area3D
@export var chasing_officers: Node3D
var event_triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collider.overlaps_body(player) && !event_triggered:
		for chasing_officer in chasing_officers.get_children():
			chasing_officer.chasing = true
			event_triggered = true
