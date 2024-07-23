extends AnimatedSprite2D

@export var level_icon:String = "Dream_1"
@export var level_type:String = "Dream"
@onready var button:Button = $Button
@onready var anim:AnimationPlayer = $AnimationPlayer

func _ready():
	animation = level_icon
	set_frame(0)

func _process(delta):
	if (button.is_hovered()):
		if(level_type == "Dream"):
			anim.play("Dream_Hovered")
		else:
			anim.play("Real_Hovered")
	else:
		anim.stop()
	if(!button.is_hovered() and get_frame() != 0):
		set_frame(0)
