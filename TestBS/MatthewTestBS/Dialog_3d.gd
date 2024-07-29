extends Sprite3D

@export var dialog: Array[String] = []
@export var scroll_time: float = 0.0
@onready var d_text = $Window/DialogText
var page: int = 0

func _ready():
	d_text.bbcode_text = dialog[page]
	d_text.set_visible_characters(0)
	$Timer.set_wait_time(scroll_time)

func _input(event):
	if(event.is_action_pressed("interact")):
		if(page < dialog.size() - 1 and d_text.get_visible_characters() >= d_text.get_total_character_count()):
			page += 1
			d_text.bbcode_text = dialog[page]
			$Timer.start()
		elif(page < dialog.size() - 1 and d_text.get_visible_characters() < d_text.get_total_character_count()):
			d_text.set_visible_characters(d_text.get_total_character_count())
			$Timer.stop()
		elif(page == dialog.size() - 1):
			hide()

func _on_timer_timeout():
	d_text.set_visible_characters(d_text.get_visible_characters() + 1)
	if (d_text.get_visible_characters() > d_text.get_total_character_count()):
		$Timer.stop()
