extends Node

@onready var transition_manager:Node = $Main_Menu_Transition_Manager

var pressed:bool = false

func _process(delta):
	if(Input.is_action_pressed("escape") and !pressed):
		pressed = true
		transition_manager.scene_to_load = SceneReferences.main_menu
		transition_manager.scene_change()
