extends Marker3D

@export var wait:bool = false
@export var wait_time:float = 1
@export var change_speed:bool = false
@export var speed_value:float = 0
@export var speed_multiplyer:float = 0
@export var turn_towards:bool = false

@onready var turn_target:Marker3D = $Marker3D
