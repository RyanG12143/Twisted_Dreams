extends Node

var right_doors: Node3D
var left_doors: Node3D
var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	right_doors = $Right_Doors
	left_doors = $Left_Doors
	open()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Open train doors
func open():
	if !is_open:
		for right_door in right_doors.get_children():
			var door_movement = right_door.global_transform.origin + (-right_door.global_transform.basis.x * 1.4)
			var tween = create_tween()
			tween.tween_property(right_door, "global_position", door_movement, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		
		for left_door in left_doors.get_children():
			var door_movement = left_door.global_transform.origin + (left_door.global_transform.basis.x * 1.4)
			var tween = create_tween()
			tween.tween_property(left_door, "global_position", door_movement, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		is_open = true

# Close train doors
func close():
	if is_open:
		for right_door in right_doors.get_children():
			var door_movement = right_door.global_transform.origin + (right_door.global_transform.basis.x * 1.4)
			var tween = create_tween()
			tween.tween_property(right_door, "global_position", door_movement, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

		for left_door in left_doors.get_children():
			var door_movement = left_door.global_transform.origin + (-left_door.global_transform.basis.x * 1.4)
			var tween = create_tween()
			tween.tween_property(left_door, "global_position", door_movement, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		is_open = false

# Spawns train npcs
func spawn_npc():
	pass
