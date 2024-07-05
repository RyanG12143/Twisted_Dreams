extends Node

@onready var transition = $Transition
@export var scene_to_load: PackedScene
@export var transition_collider: Area3D
@export var player: CharacterBody3D

signal change_level

func _ready():
	await owner.ready
	transition.play("fade_in")

func _process(delta):
	if transition_collider.overlaps_body(player):
		transition.play("fade_out")

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		get_tree().change_scene_to_packed(scene_to_load)
