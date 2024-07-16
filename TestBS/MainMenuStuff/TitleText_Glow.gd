extends Sprite2D

const MIN_LIGHT:float = 1.1

const MAX_LIGHT:float = 1.25

const LIGHT_CHANGE_AMOUNT = 0.0002

@onready var sprite:Sprite2D = self



var glow_increasing:bool = true

func _ready():
	sprite.self_modulate.r = MIN_LIGHT
	sprite.self_modulate.g = MIN_LIGHT
	sprite.self_modulate.b = MIN_LIGHT

func _process(delta):
	print(sprite.self_modulate.r)
	if(sprite.self_modulate.r < MAX_LIGHT and glow_increasing):
		sprite.self_modulate.r += LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.g += LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.b += LIGHT_CHANGE_AMOUNT
	elif(sprite.self_modulate.r >= MAX_LIGHT and glow_increasing):
		glow_increasing = false
		
	if (sprite.self_modulate.r > MIN_LIGHT and !glow_increasing):
		sprite.self_modulate.r -= LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.g -= LIGHT_CHANGE_AMOUNT
		sprite.self_modulate.b -= LIGHT_CHANGE_AMOUNT
	elif(sprite.self_modulate.r <= MIN_LIGHT and !glow_increasing):
		glow_increasing = true
