extends Node

@onready var white_logo:Sprite2D = $WhiteLogo
@onready var glow_logo:Sprite2D = $AbysmalTwistedDreamsVersion

var opacity_swap:bool = false
var timer:float = 0

func _ready():
	white_logo.modulate.a = 1
	glow_logo.modulate.a = 0
	await get_tree().create_timer(2).timeout

func _process(delta):
	if(opacity_swap):
		
