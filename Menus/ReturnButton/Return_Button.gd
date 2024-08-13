extends AnimatedSprite2D

@export var transition_manager:Node = null
@export_enum("Main Menu", "Level Select Menu") var level_to_load:String = "Main Menu"

@onready var button:Button = $Button

func _ready():
	frame = 0

func _process(delta):
	if(frame == 0 && button.is_hovered()):
		frame = 1
	elif(frame == 1 && !button.is_hovered()):
		frame = 0


func _on_button_pressed():
	get_owner().pressed = true
	if(level_to_load == "Main Menu"):
		transition_manager.scene_to_load = SceneReferences.main_menu
	elif(level_to_load == "Level Select Menu"):
		transition_manager.scene_to_load = SceneReferences.play_menu
	transition_manager.scene_change()
