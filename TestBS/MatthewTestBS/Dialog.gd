extends Control

@export var dialog: Array[String] = []
@export var wait_time: float = 0.05
@export var char_speaking: int = 0

@onready var d_text = $DialogText

var page: int = 0

func _ready():
	if page < dialog.size():
		d_text.bbcode_text = dialog[page]
		d_text.set_visible_characters(0)
		$Timer.set_wait_time(wait_time)

func change_page():
	if page < dialog.size() - 1:
		await(get_tree().create_timer(0.5).timeout)
		page += 1
		d_text.bbcode_text = dialog[page]
		d_text.set_visible_characters(0)
		$Timer.start()
	elif page == dialog.size() - 1:
		await(get_tree().create_timer(1).timeout)
		hide()

func _on_timer_timeout():
	d_text.set_visible_characters(d_text.get_visible_characters() + 1)
	if d_text.get_visible_characters() > d_text.get_total_character_count():
		$Timer.stop()
		change_page()

