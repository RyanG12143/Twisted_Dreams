extends Node

@onready var transition = $Transition
#@export var scene_to_load: PackedScene
#@export var transition_collider: Area3D

func _ready():
	await owner.ready
	transition.play("fade_in")

func player_collision(transition_collider):
	if transition_collider.body_entered is CharacterBody3D:
		transition.play("fade_out")

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		pass
		#get_tree().change_scene_to_packed(scene_to_load)
