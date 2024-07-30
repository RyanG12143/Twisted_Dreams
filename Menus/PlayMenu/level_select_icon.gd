extends AnimatedSprite2D

@export var level_number:int = 1

@export var level_type:String = "Dream"

@export var disabled:bool = false

@export var transition_manager:Node = null

@export_enum(
	"Dream Level 1",
	"Real Level 1",
	) var level_to_load:String = "Dream Level 1"

@onready var button:Button = $Button

@onready var anim:AnimationPlayer = $AnimationPlayer

@onready var nums:AnimatedSprite2D = $Numbers

var pressed:bool = false


func _ready():
	animation = level_type
	nums.animation = level_type
	set_frame(0)
	nums.set_frame((level_number * 2) - 2)
	if(disabled):
		button.set_default_cursor_shape(0)
		modulate.r = 0.35
		modulate.g = 0.35
		modulate.b = 0.35
	else:
		button.set_default_cursor_shape(2)
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1

func _process(delta):
	if(!disabled):
		if (button.is_hovered()):
			if(level_type == "Dream"):
				anim.play("Dream_Hovered")
			else:
				anim.play("Real_Hovered")
			nums.set_frame((level_number * 2) - 1)
		else:
			anim.stop()
		if(!button.is_hovered() and get_frame() != 0):
			set_frame(0)
			nums.set_frame((level_number * 2) - 2)



func _on_button_pressed():
	transition_manager.scene_to_load = SceneReferences.level_dict[level_to_load]
	transition_manager.scene_change()
