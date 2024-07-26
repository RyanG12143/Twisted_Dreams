extends Sprite3D

@export var dialog: Array[String] = []
@export var scroll_time: float = 0.0
@onready var d_text = $DialogText
var page: int = 0

func _ready():
	d_text.set_text(dialog[page])

func _input(event):
	if(event.is_action_pressed("interact")):
		if(page < dialog.size() - 1):
			page += 1
			d_text.set_text(dialog[page])
		elif(page == dialog.size() - 1):
			hide()
