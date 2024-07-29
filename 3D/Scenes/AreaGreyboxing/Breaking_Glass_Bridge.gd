extends Node3D

@export var player: CharacterBody3D
@export var collider: Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collider.overlaps_body(player):
		pass
		#print("collided")
		#queue_free()
