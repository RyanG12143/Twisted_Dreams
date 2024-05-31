extends Node2D

func _on_first_level_pressed():
	get_tree().change_scene_to_file("res://TestBS/LeoPuzzlePrototype/world.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")

func _on_level_2_pt_1_pressed():
	get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/GrayboxingTest.tscn")
