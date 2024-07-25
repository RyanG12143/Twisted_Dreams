extends Sprite3D

@export var dialog: Array[String] = []
@export var scroll_time: float = 0.0
@onready var d_text = $DialogText
var page: int = 0
