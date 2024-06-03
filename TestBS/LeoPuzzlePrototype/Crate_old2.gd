extends CharacterBody2D
## Grabbable, weighted crates.

## State of the crate
var state:String
## Essentially a falling speed.
var gravity:int = 10
## Original position of the crate.
var reset_position:Vector2
## The player.
var player:CharacterBody2D
## Timer.
var timer:float = 0

## Sets some default values.
func _ready():
	player = globals.character_one
	start_normal()
	state = "normal"
	reset_position = position

func _process(delta):
	timer += delta
	
	match state:
		"normal":
			velocity.y += gravity
			if(Input.is_action_pressed("crate_pick_up") && timer > 0.35):
				for body in $Area2D.get_overlapping_bodies():
					if body == player:
						start_grabbed()
						state = "grabbed"
		"grabbed":
			position = Vector2(player.position.x + 30, player.position.y -10)
			if(Input.is_action_pressed("crate_pick_up") && timer > 0.35):
					start_normal()
					state = "normal"
	move_and_slide()

func start_grabbed():
	if (player.has_crate == true):
		state = "normal"
		return
	timer = 0
	set_collision_layer_value(3, false)
	set_collision_mask_value(2, false)
	player.has_crate = true

func start_normal():
	timer = 0
	set_collision_layer_value(3, true)
	set_collision_mask_value(2, true)
	player.has_crate = false
