extends Node

@onready var transition = $Transition
@export var scene_to_load: String
@export var transition_collider: Area3D
@export var player: CharacterBody3D

func _ready():
	await owner.ready
	transition.play("fade_in")

func _process(delta):
	if transition_collider.overlaps_body(player):
		transition.play("fade_out")

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		var scene_load = load(SceneReferences.level_dict_3D[scene_to_load])
		get_tree().change_scene_to_packed(scene_load)
