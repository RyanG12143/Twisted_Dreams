extends Node
## Manages Main Menu scene transitions.

@onready var transition = $Transition
@export var scene_to_load: PackedScene

func _ready():
	await owner.ready
	transition.play("fade_in")
	

func scene_change():
	transition.play("fade_out")

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		get_tree().change_scene_to_packed(scene_to_load)
