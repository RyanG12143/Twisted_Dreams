extends Node

@export var train: Node3D
var in_station: bool = true
@export var spawn_position: Marker3D
@export var arrive_position: Marker3D
@export var depart_position: Marker3D
signal train_arrive
signal train_doors_open
signal train_doors_closed


# Called when the node enters the scene tree for the first time.
func _ready():
	await train.ready
	
	await get_tree().create_timer(3).timeout
	train.close()
	await get_tree().create_timer(3).timeout
	depart()

func depart():
	if in_station:
		#var train_movement = train.global_transform.origin + (train.global_transform.basis.x * 200)
		var tween = create_tween()
		tween.tween_property(train, "global_position", depart_position.global_position, 10).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		in_station = false
		tween.tween_callback(arrive).set_delay(5)

func arrive():
	if !in_station:
		train.global_position = spawn_position.global_position
		#var train_movement = train.global_transform.origin + (train.global_transform.basis.x * 200)
		var tween = create_tween()
		tween.tween_property(train, "global_position", arrive_position.global_position, 10).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		in_station = true
		tween.tween_callback(emit_signal.bind("train_arrive"))
		tween.tween_callback(train.open)
		tween.tween_callback(emit_signal.bind("train_doors_open")).set_delay(3)
		tween.tween_callback(train.close).set_delay(7)
		tween.tween_callback(emit_signal.bind("train_doors_closed"))
		tween.tween_callback(depart).set_delay(4)

func print_train_arrive():
	print("train_arrive")

func print_train_doors_open():
	print("train_doors_open")

func print_train_doors_close():
	print("train_doors_closed")
