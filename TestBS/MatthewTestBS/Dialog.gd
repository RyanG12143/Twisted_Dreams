extends Control

@export var dialog: Array[String] = []
@export var wait_time: float = 0.05
var page: int = 0

func _ready():
	if page < dialog.size():
		$Polygon2D/DialogText.bbcode_text = dialog[page]
		$Polygon2D/DialogText.set_visible_characters(0)
		$Timer.set_wait_time(wait_time)

func change_page():
	if page < dialog.size() - 1:
		await(get_tree().create_timer(0.5).timeout)
		page += 1
		$Polygon2D/DialogText.bbcode_text = dialog[page]
		$Polygon2D/DialogText.set_visible_characters(0)
		$Timer.start()
	elif page == dialog.size() - 1:
		await(get_tree().create_timer(1).timeout)
		hide()

func _on_timer_timeout():
	$Polygon2D/DialogText.set_visible_characters($Polygon2D/DialogText.get_visible_characters() + 1)
	if $Polygon2D/DialogText.get_visible_characters() > $Polygon2D/DialogText.get_total_character_count():
		$Timer.stop()
		change_page()
