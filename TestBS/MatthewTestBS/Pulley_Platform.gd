extends Node2D

@onready var platform = $Platform
@onready var start_pos: Vector2 = position
@export var distance: Vector2 = Vector2.DOWN * 192
@export var speed: float = 3.0

var tween = $Pulley_Platform.get_tree().create_tween()
var objects: int = 0

func move_down():
	var duration: float = distance.length() / float(speed * globals.UNIT_SIZE)
	tween.interpolate_property()
