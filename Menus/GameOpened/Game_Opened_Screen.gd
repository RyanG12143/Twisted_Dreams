extends Node

const MIN_LIGHT:float = 1.0

const MAX_LIGHT:float = 1.1

const LIGHT_CHANGE_AMOUNT = 0.0001

var glow_increasing:bool = false

@onready var white_logo:Sprite2D = $WhiteLogo
@onready var glow_logo:Sprite2D = $AbysmalTwistedDreamsVersion

var opacity_swap:bool = false
var timer:float = 0

func _ready():
	glow_logo.self_modulate.r = MIN_LIGHT
	glow_logo.self_modulate.g = MIN_LIGHT
	glow_logo.self_modulate.b = MIN_LIGHT
	white_logo.modulate.a = 1
	glow_logo.modulate.a = 0
	await get_tree().create_timer(1.5).timeout
	opacity_swap = true

func _process(delta):
	if(opacity_swap):
		timer += delta/6.0
		if(white_logo.modulate.a > 0):
			white_logo.modulate.a = 1 - timer
		if(glow_logo.modulate.a < 1):
			glow_logo.modulate.a = timer
	
	if(glow_logo.modulate.a >= 1):
		if(glow_logo.self_modulate.r < MAX_LIGHT):
			glow_logo.self_modulate.r += LIGHT_CHANGE_AMOUNT
			glow_logo.self_modulate.g += LIGHT_CHANGE_AMOUNT
			glow_logo.self_modulate.b += LIGHT_CHANGE_AMOUNT
			return
		else:
			
			$Main_Menu_Transition_Manager.scene_to_load = SceneReferences.main_menu
			$Main_Menu_Transition_Manager.scene_change()
		glow_logo.self_modulate.r -= LIGHT_CHANGE_AMOUNT
		glow_logo.self_modulate.g -= LIGHT_CHANGE_AMOUNT
		glow_logo.self_modulate.b -= LIGHT_CHANGE_AMOUNT
