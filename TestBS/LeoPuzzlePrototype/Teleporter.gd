extends AnimatedSprite2D
class_name Teleporter
## Teleporters that connect in pairs, allowing entities to travel through them, when active.
## ENSURE THAT ROTATION IS SET TO EITHER 0 OR 180!!!

## Camera transition time while teleporting.
const TRANSITION_TIME:float = 0.5

## The animation player.
@onready var anim = $AnimationPlayer

## Teleporter to which this one is paired with(ONLY SET FOR ONE OF THE TWO IN A PAIR).
@export var teleports_to:Teleporter = null

## Number of active inputs affecting the teleporter.
var inputs:int = 0
## How many inputs are required to activate the teleporter.
@export var inputs_required:int = 1

## Whether or not the teleporter is the assigner in the pair.
var is_assigner = null

## Whether or not the teleporter is enabled.
var teleporter_enabled:bool = false

## Weight of the lerp controlling camera position when teleporting(don't change this).
var lerp_weight:float = 1
## Startpoint of the character when performing a teleport.
var startpoint:Vector2 = Vector2(0,0)
## Endpoint of the character when performing a teleport
var endpoint:Vector2 = Vector2(0,0)
## Timer.
var timer:float = TRANSITION_TIME
## Tween.
var tween:Tween

var character_teleporting:CharacterBody2D = null
var character_is_teleporting:bool = false

## Pairs teleporters together.
## Prints a message in the console to warn developers is teleporters are not paired correctly.
func _ready():
	anim.play("disabled")
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	if(teleports_to != null):
		await get_tree().create_timer(0.01).timeout
		if(teleports_to.teleports_to == null):
			teleports_to.teleports_to = self
			is_assigner = true
			teleports_to.is_assigner = false
			teleports_to.inputs_required = inputs_required
		else:
			print("ERROR WITH TELEPORTER PAIRING!!!")



func _process(delta):
	timer += delta
	if (timer > TRANSITION_TIME): timer = TRANSITION_TIME
	lerp_weight = (tween.interpolate_value(0.0, 1.0, timer, TRANSITION_TIME, Tween.TRANS_SINE, Tween.EASE_OUT))
	
	if(character_is_teleporting):
		if(timer != TRANSITION_TIME):
			globals.character_control = 0
			character_teleporting.global_position = lerp(startpoint, endpoint, lerp_weight)
		else:
			character_teleporting.global_position = endpoint
			character_teleporting.set_collision_layer_value(2, true)
			character_teleporting.set_collision_mask_value(1, true)
			character_teleporting.set_collision_mask_value(3, true)
			character_teleporting.visible = true
			globals.character_control = globals.next_controlled_character
			character_teleporting.gravity_enabled = true
			add_character_velocity(character_teleporting, delta)
			globals.Character_Swapped.emit()
			character_is_teleporting = false

## Adds velocity to characters after they exit teleporters.
func add_character_velocity(character, delta):
	var temp:int = 20
	if(teleports_to.rotation_degrees == 0):
		while(temp > 0):
			character.velocity.x -= temp
			temp -= delta
	else:
		while(temp > 0):
			character.velocity.x += temp
			temp -= delta

## Handles additions of inputs.
func add_input():
	if(is_assigner):
		inputs += 1
		teleports_to.inputs += 1
		if(inputs >= inputs_required && teleporter_enabled == false):
			teleporter_enabled = true
			teleports_to.teleporter_enabled = true
			anim.play("enabled")
			teleports_to.anim.play("enabled")

## Handles removals of inputs.
func remove_input():
	if(is_assigner):
		inputs -= 1
		teleports_to.inputs += 1
		if(inputs < inputs_required && teleporter_enabled == true):
			teleporter_enabled = false
			teleports_to.teleporter_enabled = false
			anim.play("disabled")
			teleports_to.anim.play("disabled")



func _on_area_2d_body_entered(body):
	if(teleporter_enabled):
		if(body.is_in_group("Can_Press_Buttons")):
			if(body.is_in_group("Player") && character_is_teleporting == false):
				if(teleports_to.rotation_degrees == 0):
					endpoint = teleports_to.global_position - Vector2(15,0)
				else:
					endpoint = teleports_to.global_position - Vector2(-15,0)
				globals.character_control = 0
				body.set_collision_layer_value(2, false)
				body.set_collision_mask_value(1, false)
				body.set_collision_mask_value(3, false)
				body.visible = false
				body.gravity_enabled = false
				timer = 0
				startpoint = body.global_position
				character_teleporting = body
				character_is_teleporting = true
			if(body is Crate):
				if(teleports_to.rotation_degrees == 0):
					body.teleport_location = teleports_to.global_position - Vector2(10,-10)
				else:
					body.teleport_location = teleports_to.global_position - Vector2(-10,-10)
				body.teleport_state = true
				await get_tree().create_timer(0.05).timeout
				if(teleports_to.rotation_degrees == 0):
					body.set_deferred("linear_velocity", Vector2(-225, body.linear_velocity.y))
				else:
					body.set_deferred("linear_velocity", Vector2(225, body.linear_velocity.y))
