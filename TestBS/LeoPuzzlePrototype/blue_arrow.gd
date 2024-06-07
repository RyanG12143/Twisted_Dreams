extends Sprite2D
## Blue arrow that appears above the character being controlled(upon swapping characters).


## Time that the arrow is visible on screen for.
const ARROW_TIMER:float = 1.8

## Timer.
var timer:float = 0

## Connects signals, and calls character_swap() so the arrow appears above the character being controlled by default.
func _ready():
	globals.Character_Swapped.connect(character_swap)
	self_modulate.a = 0
	character_swap()

## Controls the opacity after it is initally made visible by character_swap().
func _process(delta):
	if(self_modulate.a != 0):
		timer += delta
		if(globals.next_controlled_character == 1):
			position = Vector2(globals.character_one.position.x + (globals.character_one.Sprite.texture.get_width()/1.2), globals.character_one.position.y - (globals.character_one.Sprite.texture.get_height()/2.0))
		elif(globals.next_controlled_character == 2):
			position = Vector2(globals.character_two.position.x + (globals.character_two.Sprite.texture.get_width()/1.2), globals.character_two.position.y - (globals.character_two.Sprite.texture.get_height()/2.0))
		else:
			self_modulate.a = 0
			return
		self_modulate.a = (ARROW_TIMER - timer)
		if(timer > ARROW_TIMER):
			self_modulate.a = 0
			timer = 0
	else:
		timer = 0

## Called when the character is swapped, making the arrow visible.
func character_swap():
	if(globals.character_one != null && globals.character_two != null):
		timer = 0
		self_modulate.a = 1
