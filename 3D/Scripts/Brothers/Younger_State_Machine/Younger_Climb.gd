extends Younger_State
class_name Younger_Climb

@export var move_speed := 10.0

func Enter():
	can_jump = false
	var v_move_time = 1
	var h_move_time = 0.4
	var vertical_movement = younger_brother.global_transform.origin + Vector3(0, ledge_height.to_local(ledge_height.get_collision_point()).y + 1.4, 0)
	var forward_movement = younger_brother.global_transform.origin + (-younger_brother._player_direction.global_transform.basis.z * 1.2)
	forward_movement.y += ledge_height.to_local(ledge_height.get_collision_point()).y + 1.4
	
	var tween = create_tween()
	tween.tween_property(younger_brother, "global_position", vertical_movement, v_move_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(younger_brother, "global_position", forward_movement, h_move_time).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	can_jump = true
	called_climb = false
	called_grab = false
	can_turn = true
	enable_gravity = true
	Transitioned.emit(self, "Younger_Idle")

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	if not movement_enabled: return
	

	#if INSERT STATE CHANGE CONDITION HERE:
		#Transitioned.emit(self, "Run")

func _process(delta):
	super(delta)
