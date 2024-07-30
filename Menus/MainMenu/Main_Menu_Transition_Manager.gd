extends Node
## Manages Main Menu scene transitions.

@onready var transition = $Transition
@onready var color_rect = $Transition/ColorRect
@export var scene_to_load: PackedScene

func _ready():
	await owner.ready
	color_rect.set_mouse_filter(2)
	transition.play("fade_in")
	

func scene_change():
	transition.play("fade_out")
	color_rect.set_mouse_filter(0)

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		get_tree().change_scene_to_packed(scene_to_load)
