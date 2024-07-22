extends ColorCodedMechanic
## Blooming flowers that can be bloomed, but not unbloomed (blooming send a signal to reciever).

signal Flower_Bloomed

@onready var Area:Area2D = $Area2D

## Whether or not the flower is bloomed.
var flower_bloomed:bool = false

## Sets flower to unbloomed by default.
func _ready():
	set_frame(0)


## Detects if player enters the flower area and blooms it if interacted with.
func _process(delta):
	if(!flower_bloomed):
		for body in Area.get_overlapping_bodies():
				if body.is_in_group("Player"):
					if(Input.is_action_just_pressed("interact")):
						if(((globals.character_control == 1) and (body == globals.character_one)) or ((globals.character_control == 2) and (body == globals.character_two))):
								set_frame(1)
								flower_bloomed = true
								emit_signal("Flower_Bloomed")
