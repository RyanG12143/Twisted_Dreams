extends Node

@onready var physics_door_1: RigidBody3D = %PhysicsDoor
@onready var physics_door_2: RigidBody3D = %PhysicsDoor2

# Called when the node enters the scene tree for the first time.
func _ready():
	physics_door_1.constant_force = physics_door_1.global_transform.basis.x * Vector3(20, 20, 20)
	
	physics_door_2.constant_force = physics_door_2.global_transform.basis.x * Vector3(20, 20, 20)
