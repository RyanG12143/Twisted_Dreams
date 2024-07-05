extends CanvasLayer

@export var dialog: Array[String] = []
var page: int = 0

func _ready():
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true
	show()
	$DialogText.text = dialog[page]
	$DialogText.set_visible_characters(0)
	set_process_input(true)

func _input(event):
	$ScrollingTimer.start()
	if InputEventMouseButton and event.is_pressed():
		if $DialogText.get_visible_characters() > $DialogText.get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				$DialogText.text = dialog[page]
				$DialogText.set_visible_characters(0)
			elif page == dialog.size() - 1:
				hide()
				get_tree().paused = false
		else:
			$DialogText.set_visible_characters($DialogText.get_total_character_count())

func _on_scrolling_timer_timeout():
	$DialogText.set_visible_characters($DialogText.get_visible_characters() + 1)

