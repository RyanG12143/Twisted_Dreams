extends Marker3D

signal waypoint_freed

## NPC will wait at waypoint when enabled
@export var wait:bool = false
## Time that npc will wait at waypoint
@export var wait_time:float = 1
## NPC will change speed to given values if values are > 0
@export var change_speed:bool = false
## NPC will set speed to given value
@export var speed_value:float = 0
## NPC will set speed multiplyer to given value
@export var speed_multiplyer:float = 0
## NPC will turn towards Marker3D Child when enabled. [br][br]
## ENABLE EDITABLE CHILDREN
@export var turn_towards:bool = false
## NPC will be given a new path from New Paths when enabled
@export var give_new_path:bool = false
## Will make path selection random
@export var random_new_path:bool = false
## Paths npc will choose from when being given new path
@export var new_paths:Array[Node3D]
## When true NPC will check if next node is empty
@export var queue:bool = false

## Variable to check if waypoint is occupied, used when prior node is a queue node
@export var empty:bool = true

## Target to turn towards when turn_towards is enabled
@onready var turn_target:Marker3D = $Turn_Target

func emptied():
	empty = true
	emit_signal("waypoint_freed")
