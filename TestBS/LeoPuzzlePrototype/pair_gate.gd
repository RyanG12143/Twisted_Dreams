extends Node
## A gate that opens when both characters are near it, and blocks the player from going backwards.

## Sprites and colliders for the gate and blocker, respectively.
@onready var gate_pillar:AnimatedSprite2D = $Gate/ForwardPillar
@onready var gate_bars:AnimatedSprite2D = $Gate/Gate
@onready var gate_collider:CollisionShape2D = $Gate/CollisionShape2D
@onready var blocker_pillar:AnimatedSprite2D = $Path_Blocker/ForwardPillar
@onready var blocker_bars:AnimatedSprite2D = $Path_Blocker/Gate
@onready var blocker_collider:CollisionShape2D = $Path_Blocker/CollisionShape2D

## Number of characters within the detection area.
var nearby_character_num:int = 0

## Is gate already used?
var gate_used:bool = false

## Disables and hides the blocker.
func _ready():
	gate_pillar.set_frame(0)
	gate_bars.set_frame(0)
	blocker_pillar.set_frame(0)
	blocker_bars.set_frame(11)
	blocker_collider.set_deferred("disabled", true)

## Enables and reveals the blocker.
func enable_blocker():
	blocker_collider.set_deferred("disabled", false)
	while(blocker_bars.get_frame() != 0):
		blocker_bars.set_frame(blocker_bars.get_frame() - 1)
		await get_tree().create_timer(0.1).timeout

	

## Disables and hides the gate.
func disable_gate():
	gate_collider.set_deferred("disabled", true)
	while(gate_bars.get_frame() != 11):
		gate_bars.set_frame(gate_bars.get_frame() + 1)
		await get_tree().create_timer(0.1).timeout


func _on_detection_area_body_entered(body):
	if(!gate_used):
		if body.is_in_group("Player") and (nearby_character_num < 2):
			nearby_character_num += 1
			if (body == globals.character_one):
				gate_pillar.set_frame(3)
			else:
				gate_pillar.set_frame(2)
			if(nearby_character_num == 2):
				gate_pillar.set_frame(1)
				blocker_pillar.set_frame(1)
				enable_blocker()
				disable_gate()
				gate_used = true

func _on_detection_area_body_exited(body):
	if(!gate_used):
		if body.is_in_group("Player") and (nearby_character_num > 0) :
			nearby_character_num -= 1.
			gate_pillar.set_frame(0)
