extends RichTextLabel

var dialog = ["This is a dialog box, yeah?", "Damn that's crazy"]
var page: int = 0

func _ready():
	text = dialog[page]
	set_visible_characters(0)
	set_process_input(true)

func _input(event):
	if event == InputEventMouseButton and event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size - 1:
				page += 1
				text = dialog[page]

func _on_scrolling_timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
