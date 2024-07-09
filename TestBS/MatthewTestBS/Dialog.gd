extends Control

@export var dialog: Array[String] = []
@export var wait_time: float = 0.05
var page: int = 0

func _ready():
	$DialogText.bbcode_text = dialog[page]
	$DialogText.set_visible_characters(0)
	$Timer.set_wait_time(wait_time)

func _process(delta):
	if $DialogText.get_visible_characters() > $DialogText.get_total_character_count():
		if page < dialog.size() - 1:
			await(get_tree().create_timer(0.5).timeout)
			change_page()
		elif page == dialog.size() - 1:
			await(get_tree().create_timer(1).timeout)
			hide()

func change_page():
	page += 1
	print(page)
	$DialogText.bbcode_text = dialog[page]
	$DialogText.set_visible_characters(0)

func _on_timer_timeout():
	$DialogText.set_visible_characters($DialogText.get_visible_characters() + 1)
