extends CanvasLayer

func _process(delta):
	if(get_tree().paused == true):
		hide()
	else:
		show()
	if(Input.is_action_pressed("3Dsprint")):
		$Icon.animation = "Run"
	else:
		$Icon.animation = "Walk"
