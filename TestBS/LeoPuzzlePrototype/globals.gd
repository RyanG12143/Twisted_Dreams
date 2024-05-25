extends Node2D

const UNIT_SIZE = 96
var character_control = 1
var next_controlled_character = 1
var character_one
var character_two

signal Character_Swapped

func set_character_one(character: CharacterBody2D):
	character_one = character
	character_one.top_level = true
	
func set_character_two(character: CharacterBody2D):
	character_two = character
	character_two.top_level = true

func _process(delta):
	if(Input.is_action_just_pressed("ui_character_swap")):
		emit_signal("Character_Swapped")
		if(character_control == 1):
			next_controlled_character = 2
			character_control = 0
			character_two.z_index = 1
			character_one.z_index = 0
			await get_tree().create_timer(0.2).timeout
			character_control = 2
		elif(character_control == 2):
			next_controlled_character = 1
			character_control = 0
			character_one.z_index = 1
			character_two.z_index = 0
			await get_tree().create_timer(0.2).timeout
			character_control = 1
			
