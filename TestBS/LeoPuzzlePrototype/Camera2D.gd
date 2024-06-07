extends Camera2D
## Controls the position and movement of the camera.

## Camera transition time between characters when swapping.
const TRANSITION_TIME:float = 0.33
## Freecam move speed.
const FREECAM_SPEED:float = 4

## Weight of the lerp controlling camera position when transitioning between characters(don't change this).
var lerp_weight:float = 1
## Startpoint of the camera when performing a transition.
var startpoint:Vector2 = Vector2(0,0)
## Timer.
var timer:float = TRANSITION_TIME
## Tween.
var tween:Tween

## Character controlled before going freecam.
var prev_char_control:int = 1

## Connects signals and creates the tween.
func _ready():
	globals.Character_Swapped.connect(character_swap)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)

## Controls the position of the camera during a transition.
func _process(delta):
	timer += delta
	if (timer > TRANSITION_TIME): timer = TRANSITION_TIME
	
	lerp_weight = (tween.interpolate_value(0.0, 1.0, timer, TRANSITION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT))
	
	if(Input.is_action_just_pressed("free_camera") && !globals.swap_active):
		if(globals.character_control != 0):
			prev_char_control = globals.next_controlled_character
			globals.next_controlled_character = 0
		else:
			globals.next_controlled_character = prev_char_control
			globals.character_control = globals.next_controlled_character
			zoom = Vector2(2.5, 2.5)
			character_swap()
			globals.Character_Swapped.emit()
			
	
	if(globals.character_one != null && globals.character_two != null):
		if(globals.next_controlled_character == 1):
			global_position = lerp(startpoint, globals.character_one.global_position, lerp_weight)
		elif(globals.next_controlled_character == 2):
			global_position = lerp(startpoint, globals.character_two.global_position, lerp_weight)
		else:
			globals.character_control = 0
			if(Input.is_action_pressed("ui_left")):
				global_position.x -= FREECAM_SPEED* (1/zoom.x)
			if(Input.is_action_pressed("ui_right")):
				global_position.x += FREECAM_SPEED * (1/zoom.x)
			if(Input.is_action_pressed("ui_up")):
				global_position.y -= FREECAM_SPEED * (1/zoom.x)
			if(Input.is_action_pressed("ui_down")):
				global_position.y += FREECAM_SPEED * (1/zoom.x)
			if(Input.is_action_pressed("zoom_in") and zoom.x < 4 ):
				zoom += Vector2(0.01,0.01)
			if(Input.is_action_pressed("zoom_out") and zoom.x > 1 ):
				zoom -= Vector2(0.01,0.01)
		

## Called upon character swap, prepares the camera to transition by setting necessary values to perform the transition.
func character_swap():
	startpoint = global_position
	lerp_weight = 0
	timer = 0
	
