extends Node

@onready var physics_door: RigidBody3D = %PhysicsDoor

# Called when the node enters the scene tree for the first time.
func _ready():
	physics_door.constant_force = physics_door.global_transform.basis.x * Vector3(20, 20, 20)
	print(physics_door.global_transform.basis.x)
