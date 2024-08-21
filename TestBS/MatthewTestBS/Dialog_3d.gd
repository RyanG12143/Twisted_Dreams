extends Sprite3D

@export var dialog: Array[String] = []
@export var scroll_time: float = 0.0
@export var duration: float = 0.0
@export var important: bool = false
@onready var d_text = $Sprite3D/Window/DialogText
var page: int = 0

func _ready():
	hide()

func set_important(is_important: bool):
	important = is_important

func change_page():
	if(!important):
		if(page < dialog.size() - 1):
			await(get_tree().create_timer(duration).timeout)
			page += 1
			d_text.bbcode_text = dialog[page]
			d_text.set_visible_characters(0)
			$Timer.start()
		elif(page == dialog.size() - 1):
			await(get_tree().create_timer(duration).timeout)
			hide()

func _on_timer_timeout():
	d_text.set_visible_characters(d_text.get_visible_characters() + 1)
	if(important):
		if(Input.is_action_just_pressed("interact")):
			if(page < dialog.size() - 1 and d_text.get_visible_characters() >= d_text.get_total_character_count()):
				page += 1
				d_text.bbcode_text = dialog[page]
				d_text.set_visible_characters(0)
			elif(page < dialog.size() - 1 and d_text.get_visible_characters() < d_text.get_total_character_count()):
				d_text.set_visible_characters(d_text.get_total_character_count())
			elif(page == dialog.size() - 1):
				hide()
	elif (d_text.get_visible_characters() > d_text.get_total_character_count() and !important):
		$Timer.stop()
		change_page()


func _on_trigger_box_3d_not_important():
	show()
	d_text.bbcode_text = dialog[page]
	d_text.set_visible_characters(0)
	$Timer.set_wait_time(scroll_time)
	$Timer.start()
