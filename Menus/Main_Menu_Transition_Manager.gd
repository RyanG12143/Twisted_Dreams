@tool
extends Node
## Manages Main Menu scene transitions.

@onready var transition = $Transition
@onready var color_rect = $Transition/ColorRect

var scene_to_load:String = ""

func _ready():
	await owner.ready
	color_rect.set_mouse_filter(2)
	transition.play("fade_in")

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		color_rect.visible = false
	else:
		color_rect.visible = true

func scene_change():
	transition.play("fade_out")
	color_rect.set_mouse_filter(0)

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		var scene_load = load(scene_to_load)
		get_tree().change_scene_to_packed(scene_load)
