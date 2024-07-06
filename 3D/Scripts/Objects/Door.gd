extends Node

@onready var physics_door: RigidBody3D = %PhysicsDoor

# Called when the node enters the scene tree for the first time.
func _ready():
	physics_door.constant_force = physics_door.global_transform.basis.x * Vector3(11, 11, 11)
	print(physics_door.global_transform.basis.x)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
	#print()

