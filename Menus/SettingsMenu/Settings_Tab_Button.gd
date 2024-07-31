extends AnimatedSprite2D

@export_enum(
	"Video",
	"Sound",
	"Controls",
	"Gameplay",
) var button_type:String = "Video"

@onready var button:Button = $Button
@onready var hover_effect:AnimatedSprite2D = $HoverEffect

func _ready():
	animation = button_type
	hover_effect.animation = button_type
	
	frame = 0
	hover_effect.self_modulate.a = 0
	
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

func _process(delta):
	if(button.is_hovered() and hover_effect.self_modulate.a != 0.3):
		hover_effect.self_modulate.a = 0.3
	elif(!button.is_hovered() and hover_effect.self_modulate.a != 0):
		hover_effect.self_modulate.a = 0

func _on_button_pressed():
	owner.tab_changed(button_type)
