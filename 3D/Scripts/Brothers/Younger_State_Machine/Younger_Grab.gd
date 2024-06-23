extends Younger_State
class_name Younger_Grab

func Enter():
	enable_gravity = false
	younger_brother.velocity = Vector3.ZERO
	# Facing wall normal
	mesh.rotation.y = -(atan2(player_normal.get_collision_normal().z, player_normal.get_collision_normal().x) - PI/2)
	await get_tree().create_timer(0.5).timeout
	Transitioned.emit(self, "Younger_Hang")
	

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	super(delta)
	
	

	#if INSERT STATE CHANGE CONDITION HERE:
		#Transitioned.emit(self, "Run")

func _process(delta):
	super(delta)
