extends Control

##Contains all of the dialog said
@export var dialog: Array[String] = []
##How fast the text scroll
@export var scroll_time: float = 0.05
##Delay between new dialog and the dialog bubble being on screen
@export var wait_time: float = 2.0
##For manipulating the text
@onready var d_text = $DialogText
##Which "page" in the array it's on
var page: int = 0

func _ready():
	hide()

##Either changes to the new dialog or gets rid of the dialog bubble
func change_page():
	if (page < dialog.size() - 1):
		await(get_tree().create_timer(wait_time).timeout)
		print(page)
		page += 1
		print(page)
		d_text.bbcode_text = dialog[page]
		d_text.set_visible_characters(0)
		$Timer.start()
	elif (page == dialog.size() - 1):
		await(get_tree().create_timer(wait_time).timeout)
		hide()

##Scrolls the text for the dialog
func _on_timer_timeout():
	d_text.set_visible_characters(d_text.get_visible_characters() + 1)
	if d_text.get_visible_characters() > d_text.get_total_character_count():
		$Timer.stop()
		change_page()

func set_dialog(new_dialog: Array[String]):
	dialog = new_dialog

func _on_trigger_box_2_send_dialog(char_1, char_2):
	page = 0
	set_dialog(char_1)
	if (page < dialog.size()):
		show()
		d_text.bbcode_text = dialog[page]
		d_text.set_visible_characters(0)
		$Timer.set_wait_time(scroll_time)
		$Timer.start()
