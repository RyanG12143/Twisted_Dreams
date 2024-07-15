extends CanvasLayer

var open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

#Pauses and unpauses the game
func _input(event):
	if Input.is_action_pressed("escape") and get_tree().paused == false:
		get_tree().paused = true
		show()
		$MainScreen.show()
		$SettingsMenu.hide()
		$AudioMenu.hide()
		$VisualMenu.hide()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		hide()
		get_tree().paused = false

#Unpauses the game
func _on_back_pressed():
	get_tree().paused = false
	hide()

#Goes to the settings menu
func _on_settings_pressed():
	$MainScreen.hide()
	$SettingsMenu.show()

#Opens the title screen
func _on_return_to_title_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")

#Goes back to the main menu
func _on_back_to_main_pressed():
	$SettingsMenu.hide()
	$MainScreen.show()

#Saves the game
func _on_save_pressed():
	Utils.saveGame()

#Goes to the audio menu
func _on_audio_pressed():
	$MainScreen.hide()
	$AudioMenu.show()

#Goes back to the settings menu
func _on_back_to_settings_pressed():
	$AudioMenu.hide()
	$VisualMenu.hide()
	$SettingsMenu.show()

#Goes to the visuals menu
func _on_visual_pressed():
	$SettingsMenu.hide()
	$VisualMenu.show()
	$VisualMenu/SubtitleSample.hide()

#Toggles subtitles for background characters on and off
func _on_subtitle_toggle_toggled(toggled_on):
	if toggled_on == true:
		$VisualMenu/SubtitleSample.show()
	else:
		$VisualMenu/SubtitleSample.hide()
