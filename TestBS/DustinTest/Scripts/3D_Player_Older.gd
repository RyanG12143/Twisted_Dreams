extends CharacterBody3D


const SPEED:float = 5.0
const JUMP_VELOCITY:float = 4.5
@onready var pivot = $CamOrigin
@export var sens:float = 0.5
var called_climb = false
var can_jump = true
var grab_start = false


# Raycasting
@onready var chest_ray = $Rays/Chest
@onready var head_rays = $Rays/HeadRays

#climbing
#var vertical_movement
#var forward_movement

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("3Djump") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://TestBS/DustinTest/Scenes/TitleScreen.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("3Dleft", "3Dright", "3Dforward", "3Dbackward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _process(delta):
	if Input.is_action_pressed("3Djump") and can_climb():
		grab_ledge()
		
func can_climb():
	if !chest_ray.is_colliding():
		return false
	for ray in head_rays.get_children():
		if ray.is_colliding():
			return false
	return true

func grab_ledge():
	velocity = Vector3.ZERO
	climb_ledge()
	

func climb_ledge():
	if called_climb:
		return
	called_climb = true
	climb()
	
func climb():
	can_jump = false
	var v_move_time = 1
	var h_move_time = 0.4
	var vertical_movement = global_transform.origin + Vector3(0, 1.3, 0)
	var forward_movement = global_transform.origin + (-global_transform.basis.z * 1.2)
	forward_movement.y += 1.3
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", vertical_movement, v_move_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", forward_movement, h_move_time).set_trans(Tween.TRANS_LINEAR)
	
	can_jump = true
	called_climb = false
	

