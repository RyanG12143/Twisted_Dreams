extends Control

var open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _process(delta):
	if Input.is_action_pressed("escape"):
		show()
		$MainScreen.show()
		$SettingsMenu.hide()
		$AudioMenu.show()

func _on_back_pressed():
	hide()

func _on_settings_pressed():
	$MainScreen.hide()
	$SettingsMenu.show()

func _on_return_to_title_pressed():
	get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")


func _on_back_to_main_pressed():
	$SettingsMenu.hide()
	$MainScreen.show()

func _on_save_pressed():
	Utils.saveGame()


func _on_audio_pressed():
	$SettingsMenu.hide()
	$AudioMenu.show()

func _on_back_to_settings_pressed():
	pass # Replace with function body.
