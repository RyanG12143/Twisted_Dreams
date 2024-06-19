extends AnimatedSprite2D
## Runes that can be activated, but not deactivated.

signal Rune_Activated

@onready var Area:Area2D = $Area2D

## Whether or not the rune is activated.
var rune_activated:bool = false

## Sets rune to deactive by default.
func _ready():
	set_frame(0)


## Detects if player enters the rune area and activates it.
func _process(delta):
	if(!rune_activated):
		for body in Area.get_overlapping_bodies():
				if body.is_in_group("Player"):
					if(Input.is_action_just_pressed("interact")):
						if(((globals.character_control == 1) and (body == globals.character_one)) or ((globals.character_control == 2) and (body == globals.character_two))):
								set_frame(1)
								rune_activated = true
								emit_signal("Rune_Activated")
