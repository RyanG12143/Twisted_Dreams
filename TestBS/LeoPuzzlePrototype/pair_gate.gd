extends Node
## A gate that opens when both characters are near it, and blocks the player from going backwards.

## Sprites and colliders for the gate and blocker, respectively.
@onready var gate_sprite:Sprite2D = $Gate/Sprite2D
@onready var gate_collider:CollisionShape2D = $Gate/CollisionShape2D
@onready var blocker_sprite:Sprite2D = $Path_Blocker/Sprite2D
@onready var blocker_collider:CollisionShape2D = $Path_Blocker/CollisionShape2D

## Number of characters within the detection area.
var nearby_character_num:int = 0

## Is gate already used?
var gate_used:bool = false

## Disables and hides the blocker.
func _ready():
	blocker_sprite.visible = false
	blocker_collider.set_deferred("disabled", true)

## Enables and reveals the blocker.
func enable_blocker():
	blocker_sprite.visible = true
	blocker_collider.set_deferred("disabled", false)

## Disables and hides the gate.
func disable_gate():
	gate_sprite.visible = false
	gate_collider.set_deferred("disabled", true)


func _on_detection_area_body_entered(body):
	if(!gate_used):
		if body.is_in_group("Player") and (nearby_character_num < 2):
			nearby_character_num += 1
			if(nearby_character_num == 2):
				enable_blocker()
				disable_gate()
				gate_used = true

func _on_detection_area_body_exited(body):
	if(!gate_used):
		if body.is_in_group("Player") and (nearby_character_num > 0) :
			nearby_character_num -= 1.
