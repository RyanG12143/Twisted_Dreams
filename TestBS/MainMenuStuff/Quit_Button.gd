extends AnimatedSprite2D

@onready var button:Button = $Button

func _ready():
	frame = 0

func _process(delta):
	if(frame == 0 && button.is_hovered()):
		frame = 1
	elif(frame == 1 && !button.is_hovered()):
		frame = 0


func _on_button_pressed():
	get_tree().quit()
