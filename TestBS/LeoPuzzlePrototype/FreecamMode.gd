extends Node2D

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

var follow_cam:PhantomCameraHost = null
var reset_pos:Vector2 = Vector2(0,0)

## Connects signals and creates the tween.
func _ready():
	globals.Character_Swapped.connect(character_swap)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	follow_cam = get_tree().get_root().get_node("world/Camera2D/PhantomCameraHost")

## Controls the position of the camera during a transition.
func _process(delta):
	
	#timer += delta
	#if (timer > TRANSITION_TIME): timer = TRANSITION_TIME
	#
	#lerp_weight = (tween.interpolate_value(0.0, 1.0, timer, TRANSITION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT))
	
	if(Input.is_action_just_pressed("free_camera") && !globals.swap_active):
		if(globals.character_control != 0):
			reset_pos = get_parent().global_position
			follow_cam.set_process(false)
			follow_cam.set_physics_process(false)
			prev_char_control = globals.next_controlled_character
			globals.next_controlled_character = 0
		else:
			globals.next_controlled_character = prev_char_control
			globals.character_control = globals.next_controlled_character
			character_swap()
			globals.Character_Swapped.emit()
			reset_camera()
			
			
	
	if(globals.character_one != null && globals.character_two != null):
		if(globals.next_controlled_character == 0):
			globals.character_control = 0
			if(Input.is_action_pressed("ui_left")):
				get_parent().global_position.x -= FREECAM_SPEED* (1/get_parent().zoom.x)
			if(Input.is_action_pressed("ui_right")):
				get_parent().global_position.x += FREECAM_SPEED * (1/get_parent().zoom.x)
			if(Input.is_action_pressed("ui_up")):
				get_parent().global_position.y -= FREECAM_SPEED * (1/get_parent().zoom.x)
			if(Input.is_action_pressed("ui_down")):
				get_parent().global_position.y += FREECAM_SPEED * (1/get_parent().zoom.x)
			if(Input.is_action_pressed("zoom_in") and get_parent().zoom.x < 4 ):
				get_parent().zoom += Vector2(0.01,0.01)
			if(Input.is_action_pressed("zoom_out") and get_parent().zoom.x > 0.5 ):
				get_parent().zoom -= Vector2(0.01,0.01)
	

func reset_camera():
	follow_cam.set_process(true)
	follow_cam.set_physics_process(true)
	

## Called upon character swap, prepares the camera to transition by setting necessary values to perform the transition.
func character_swap():
	startpoint = get_parent().global_position
	lerp_weight = 0
	timer = 0
	
