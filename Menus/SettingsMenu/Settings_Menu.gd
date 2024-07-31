extends Node

@onready var transition_manager:Node = $Main_Menu_Transition_Manager

var current_tab:String = ""

@onready var video_tab:AnimatedSprite2D = $MenuTabs/VideoTab
@onready var sound_tab:AnimatedSprite2D = $MenuTabs/SoundTab
@onready var controls_tab:AnimatedSprite2D = $MenuTabs/ControlsTab
@onready var gameplay_tab:AnimatedSprite2D = $MenuTabs/GameplayTab

@onready var video_screen:Node2D = $VideoScreen
@onready var sound_screen:Node2D = $SoundScreen
@onready var controls_screen:Node2D = $ControlsScreen
@onready var gameplay_screen:Node2D = $GameplayScreen

@onready var tab_array:Array = [video_tab, sound_tab, controls_tab, gameplay_tab]

var pressed:bool = false

func _ready():
	video_screen.visible = false
	sound_screen.visible = false
	controls_screen.visible = false
	gameplay_screen.visible = false
	tab_changed("Video")

func _process(delta):
	if(Input.is_action_pressed("escape") and !pressed):
		pressed = true
		transition_manager.scene_to_load = SceneReferences.main_menu
		transition_manager.scene_change()

func tab_changed(new_tab:String):
	if(current_tab == new_tab):
		pass
	else:
		current_tab = new_tab
		for tab in tab_array:
			if(tab.button_type == current_tab):
				tab.set_frame(1)
			else:
				tab.set_frame(0)
		
		if(current_tab == "Video"):
			video_screen.visible = true
			sound_screen.visible = false
			controls_screen.visible = false
			gameplay_screen.visible = false
		elif(current_tab == "Sound"):
			video_screen.visible = false
			sound_screen.visible = true
			controls_screen.visible = false
			gameplay_screen.visible = false
		elif(current_tab == "Controls"):
			video_screen.visible = false
			sound_screen.visible = false
			controls_screen.visible = true
			gameplay_screen.visible = false
		elif(current_tab == "Gameplay"):
			video_screen.visible = false
			sound_screen.visible = false
			controls_screen.visible = false
			gameplay_screen.visible = true
