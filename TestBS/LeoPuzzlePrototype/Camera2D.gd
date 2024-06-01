extends Camera2D
## Controls the position and movement of the camera.

## Camera transition time between characters when swapping.
const TRANSITION_TIME:float = 0.33

## Weight of the lerp controlling camera position when transitioning between characters(don't change this).
var lerp_weight:float = 1
## Startpoint of the camera when performing a transition.
var startpoint:Vector2 = Vector2(0,0)
## Timer.
var timer:float = TRANSITION_TIME
## Tween.
var tween:Tween

## Connects signals and creates the tween.
func _ready():
	globals.Character_Swapped.connect(character_swap)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)

## Controls the position of the camera during a transition.
func _process(delta):
	timer += delta
	if (timer > TRANSITION_TIME): timer = TRANSITION_TIME
	
	lerp_weight = (tween.interpolate_value(0.0, 1.0, timer, TRANSITION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT))
	
	if(globals.character_one != null && globals.character_two != null):
		if(globals.next_controlled_character == 1):
			global_position = lerp(startpoint, globals.character_one.global_position, lerp_weight)
		elif(globals.next_controlled_character == 2):
			global_position = lerp(startpoint, globals.character_two.global_position, lerp_weight)
		

## Called upon character swap, prepares the camera to transition by setting necessary values to perform the transition.
func character_swap():
	startpoint = global_position
	lerp_weight = 0
	timer = 0
	
