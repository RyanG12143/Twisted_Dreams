extends Sprite2D
## Tree that if both players are near it ends the level.

signal Level_Completed_2D

## Array of overlapping characters.
var overlapping_characters:Array = []

## Is level end already activated?
var activated:bool = false


func _on_area_2d_body_entered(body):
	if(!activated):
		if (body.is_in_group("Player")):
			overlapping_characters.insert(overlapping_characters.size(), body)
			if(overlapping_characters.size() == 2):
				Level_Completed_2D.emit()
				activated = true


func _on_area_2d_body_exited(body):
	if(!activated):
		if (body.is_in_group("Player") and overlapping_characters.size() > 0):
			overlapping_characters.remove_at(overlapping_characters.front())
