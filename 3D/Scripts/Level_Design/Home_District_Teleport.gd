extends Node3D

var scene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_3d_body_entered(body):
	print(body)
	if body is CharacterBody3D:
		get_tree().change_scene_to_file("uid://cq62xwmqwdoot")
