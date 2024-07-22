extends ColorCodedMechanic
## Runes that have two states, enabled or disabled.

signal Rune_Disabled
signal Rune_Enabled

@onready var Area:Area2D = $Area2D

@onready var anim:AnimationPlayer = $AnimationPlayer

## Whether or not the rune is enabled
var rune_enabled:bool = false

## Sets rune to disabled by default.
func _ready():
	if(color == "blue"):
		animation = "Blue"
	elif(color == "pink"):
		animation = "Pink"
	elif(color == "orange"):
		animation = "Orange"
	set_frame(0)

## Detects if player enters the rune area and changes the state if interacted with. Also controls rune animations.
func _process(delta):
	for body in Area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				if(Input.is_action_just_pressed("interact")):
					if(((globals.character_control == 1) and (body == globals.character_one)) or ((globals.character_control == 2) and (body == globals.character_two))):
						if(rune_enabled):
							anim.play("activation" , -1 , -1, true)
							rune_enabled = false
							emit_signal("Rune_Disabled")
						else:
							anim.play("activation")
							rune_enabled = true
							emit_signal("Rune_Enabled")
