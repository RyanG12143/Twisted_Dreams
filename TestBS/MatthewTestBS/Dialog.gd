extends Control

##Contains all of the dialog said
var dialog: Array[Node] = []
##How fast the text scroll
@export var scroll_time: float = 0.05
##Delay between new dialog and the dialog bubble being on screen
@export var wait_time: float = 2.0
##1=character 1's dialog, 2=character 2's dialog
@export var character: int = 0
##For manipulating the text
@onready var d_text = $DialogText
##Which "page" in the array it's on
var page: int = 0
##Checks if the page is the last page
var last: bool = false
##Timer
var timer: float = 0.0
##How long the dialog box is visible after the last line
const STAY_TIMER: float = 0.25

func _ready():
	hide()

func _process(delta):
	if(last):
		if(modulate.a != 0):
			timer += delta
			modulate.a = (STAY_TIMER - timer)
			if(timer > STAY_TIMER):
				modulate.a = 0
				timer = 0
				hide()

##Either changes to the new dialog or gets rid of the dialog bubble
func change_page():
	if (page < dialog.size() - 1):
		await(get_tree().create_timer(dialog[page].duration).timeout)
		page += 1
		if((character == 1 and dialog[page].char_speaking == 1) or (character == 2 and 
		dialog[page].char_speaking == 2) or dialog[page].char_speaking == 0):
			show()
			d_text.bbcode_text = dialog[page].dialog_said
			d_text.set_visible_characters(0)
		$Timer.start()
	elif (page == dialog.size() - 1):
		await(get_tree().create_timer(dialog[page].duration).timeout)
		last = true

##Scrolls the text for the dialog
func _on_timer_timeout():
	d_text.set_visible_characters(d_text.get_visible_characters() + 1)
	if d_text.get_visible_characters() > d_text.get_total_character_count():
		$Timer.stop()
		change_page()

func set_dialog(new_dialog: Array[Node]):
	dialog = new_dialog

func _on_trigger_box_send_dialog(dialogue):
	modulate.a = 1
	last = false
	page = 0
	set_dialog(dialogue)
	#if (character == 1):
		#set_dialog(char_1)
	#elif character == 2:
		#set_dialog(char_2)
	if (page < dialog.size()):
		#if ((character == 1 and start == 1) or character == 2 and start == 2):
			#show()
		#elif ((character == 1 and start == 2) or character == 2 and start == 1):
			#await(get_tree().create_timer(wait_time).timeout)
			#show()
		#elif (start == 0):
		if((character == 1 and dialog[page].char_speaking == 1) or (character == 2 and 
		dialog[page].char_speaking == 2)):
			d_text.bbcode_text = dialog[page].dialog_said
			show()
		elif(dialog[page].char_speaking == 0):
			d_text.bbcode_text = dialog[page].dialog_said
			show()
		d_text.set_visible_characters(0)
		$Timer.set_wait_time(scroll_time)
		$Timer.start()
