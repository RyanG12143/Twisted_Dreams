extends Node

@onready var transition = $Transition
#@export var scene_to_load: PackedScene

func _ready():
	await owner.ready
	transition.play("fade_in")
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		globals.death_state = true
		globals.character_control = 0
		transition.play("fade_out")
		

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		#get_tree().change_scene_to_packed(scene_to_load)
		get_tree().reload_current_scene()


func connect_enemy(death_area:Area2D):
	death_area.body_entered.connect(_on_area_2d_body_entered)
