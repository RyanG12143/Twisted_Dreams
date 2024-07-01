extends Node

@onready var transition = $Transition
@export var scene_to_load: PackedScene

func ready():
	transition.play("fade_in")

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		transition.play("fade_out")

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		get_tree().change_scene_to_packed(scene_to_load)
