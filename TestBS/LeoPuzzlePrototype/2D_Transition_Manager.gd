@tool
extends Node
## Manages 2D scene transitions (currently just deaths).

@onready var transition = $Transition
@onready var color_rect:ColorRect = $Transition/ColorRect
#@export var scene_to_load: PackedScene

func _ready():
	await owner.ready
	transition.play("fade_in")

func _process(delta):
	if Engine.is_editor_hint():
		color_rect.visible = false
	else:
		color_rect.visible = true
	

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
