extends Sprite2D

var timer = 0
const ARROW_TIMER = 1.8


func _ready():
	globals.Character_Swapped.connect(character_swap)
	self_modulate.a = 0
	character_swap()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if(self_modulate.a != 0):
		timer += delta
		if(globals.next_controlled_character == 1):
			position = Vector2(globals.character_one.position.x + 11, globals.character_one.position.y - 12)
		elif(globals.next_controlled_character == 2):
			position = Vector2(globals.character_two.position.x + 10, globals.character_two.position.y - 12)
		self_modulate.a = (ARROW_TIMER - timer)
		if(timer > ARROW_TIMER):
			self_modulate.a = 0
			timer = 0
	else:
		timer = 0

func character_swap():
	if(globals.character_one != null && globals.character_two != null):
		timer = 0
		self_modulate.a = 1
