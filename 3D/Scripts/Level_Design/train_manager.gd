extends Node

@export var train: Node3D
var in_station: bool = true
@export var spawn_position: Marker3D
@export var arrive_position: Marker3D
@export var depart_position: Marker3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#station_position = train.global_transform.basis.x
	#await get_tree().create_timer(5).timeout
	await train.ready
	
	await get_tree().create_timer(3).timeout
	train.close()
	await get_tree().create_timer(3).timeout
	depart()
	await get_tree().create_timer(12).timeout
	arrive()
	await get_tree().create_timer(11).timeout
	train.open()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func depart():
	if in_station:
		#var train_movement = train.global_transform.origin + (train.global_transform.basis.x * 200)
		var tween = create_tween()
		tween.tween_property(train, "global_position", depart_position.global_position, 10).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		in_station = false

func arrive():
	if !in_station:
		train.global_position = spawn_position.global_position
		#var train_movement = train.global_transform.origin + (train.global_transform.basis.x * 200)
		var tween = create_tween()
		tween.tween_property(train, "global_position", arrive_position.global_position, 10).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		in_station = true
