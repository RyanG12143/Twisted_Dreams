extends AnimatedSprite2D

@onready var button:Button = $Button

@export_enum("Raimi", "Enzo") var brother:String = "Enzo"

@export var transition_manager:Node = null

var pressed:bool = false

func _ready():
	animation = brother
	frame = 0

func _process(delta):
	if(frame == 0 && button.is_hovered()):
		frame = 1
	elif(frame == 1 && !button.is_hovered()):
		frame = 0

func _on_button_pressed():
	if(!pressed):
		pressed = true
		transition_manager.scene_to_load = SceneReferences.level_dict[SceneReferences.stored_scene]
		transition_manager.scene_change()
