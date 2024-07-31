extends AnimatedSprite2D

@export_enum(
	"Video",
	"Sound",
	"Controls",
	"Gameplay",
) var button_type:String = "Video"

@onready var button:Button = $Button

func _ready():
	animation = button_type
	
	if(button_type == "Video"):
		button.set_size(Vector2(550, 300))
		button.set_position(Vector2(-275, -150))
	elif(button_type == "Sound"):
		button.set_size(Vector2(580, 300))
		button.set_position(Vector2(-290, -150))
	elif(button_type == "Controls"):
		button.set_size(Vector2(900, 300))
		button.set_position(Vector2(-450, -150))
	elif(button_type == "Gameplay"):
		button.set_size(Vector2(920, 300))
		button.set_position(Vector2(-460, -150))
	
	frame = 0
