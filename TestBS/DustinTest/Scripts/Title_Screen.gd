extends Node2D

func _ready():
	#Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	# need to fix this
	# get_tree().change_scene_to_file("res://Scenes/Base/world.tscn")
	pass

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/LevelSelect.tscn")

func _on_quit_pressed():
	Utils.saveGame()
	get_tree().quit()
