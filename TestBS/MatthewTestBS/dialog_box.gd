extends CanvasLayer

@export var dialog: Array[String] = []
var page: int = 0

func _ready():
	hide()

func _input(event):
	if InputEventMouseButton and event.is_pressed():
		if $DialogText.get_visible_characters() > $DialogText.get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				if page % 2 != 0:
					$DialogBox/Character1.modulate = Color("gray")
					$DialogBox/Character2.modulate = Color("white")
				else:
					$DialogBox/Character2.modulate = Color("gray")
					$DialogBox/Character1.modulate = Color("white")
				$DialogText.text = dialog[page]
				$DialogText.set_visible_characters(0)
			elif page == dialog.size() - 1:
				$AnimationPlayer.play("go_down")
				await get_tree().create_timer(0.5).timeout
				hide()
				get_tree().paused = false
		else:
			$DialogText.set_visible_characters($DialogText.get_total_character_count())

func _on_scrolling_timer_timeout():
	$DialogText.set_visible_characters($DialogText.get_visible_characters() + 1)

func start_dialog():
	get_tree().paused = true
	show()
	$AnimationPlayer.play("go_up")
	$DialogText.text = dialog[page]
	$DialogText.set_visible_characters(0)
	$DialogBox/Character2.modulate = Color("gray")
	set_process_input(true)
	await get_tree().create_timer(0.5).timeout
	
	$ScrollingTimer.start()

func _on_area_2d_body_entered(body):
	#get_tree().paused = true
	print("Entered")
	start_dialog()
	
