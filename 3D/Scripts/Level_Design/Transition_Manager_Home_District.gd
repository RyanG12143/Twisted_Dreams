extends Node

@onready var transition = $Transition
var market_district = preload("uid://dre0o1tw818oq")

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		transition.play("fade_out")

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		get_tree().change_scene_to_packed(market_district)
