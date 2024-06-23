extends Node2D
## Stores global variables, singleton.

## Size of a "unit," used in character movement calculations and such. 
const UNIT_SIZE:int = 96
## Which character is currently being controlled.
var character_control:int = 1
## Which character is to be controlled next(when a character swap is initiated).
var next_controlled_character:int = 1
## Character one.
var character_one:CharacterBody2D
## Character two.
var character_two:CharacterBody2D

## Are the characters being swapped?
var swap_active:bool = false

signal Character_Swapped

## Gets called by character one to set it.
func set_character_one(character: CharacterBody2D):
	character_one = character
	character_one.top_level = true
	
## Gets called by character two to set it.
func set_character_two(character: CharacterBody2D):
	character_two = character
	character_two.top_level = true

## Controls character swaps.
func _process(_delta):
	if(Input.is_action_just_pressed("ui_character_swap")) and character_one and character_two && character_control != 0:
		swap_active = true
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
		swap_active = false
