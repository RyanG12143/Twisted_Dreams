extends Camera2D

var lerp_weight = 1
var startpoint = Vector2(0,0)
const TRANSITION_TIME = 0.33
var timer = TRANSITION_TIME
var tween


func _ready():
	globals.Character_Swapped.connect(_character_swap)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)


func _process(delta):
	timer += delta
	if (timer > TRANSITION_TIME): timer = TRANSITION_TIME
	
	lerp_weight = (tween.interpolate_value(0.0, 1.0, timer, TRANSITION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT))
	
	if(globals.character_one != null && globals.character_two != null):
		if(globals.character_control == 1):
			global_position = lerp(startpoint, globals.character_one.global_position, lerp_weight)
		else:
			global_position = lerp(startpoint, globals.character_two.global_position, lerp_weight)
		


func _character_swap():
	startpoint = global_position
	lerp_weight = 0
	timer = 0
	
