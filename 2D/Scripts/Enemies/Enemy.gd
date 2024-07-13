class_name Enemy
extends CharacterBody2D
## Base script for hanlding enemy behavior
##
## Calls on State_Machine to controll behaviors

## Gravity constant
const GRAVITY:float = 1200

## Movement speed of enemy
@export var SPEED:float = 5000.0
## If enabled enemy roams when player is not in range
@export var roaming:bool = true
## If enabled enemy will not leave platform
## [br]
## Does not handle flying
@export var grounded:bool = true
## If enabled enemy charges at character, after a short pause, when the character is inside the charge radius
@export var charging:bool = true
## If enabled the enemy will freeze when looked at
## [br][br]
## (Does not freeze charging)
@export var weeping:bool = false
## (DEV TOOL) Disable proccessing of node.
@export var disabled:bool = false

## Closest of the objects in targets
var target:CharacterBody2D
## Gets all player characters on ready and stores the node of each
var targets:Array[Node] = []
## Stores ray_casts for each target taht comes into range
var target_rays:Dictionary = {}
## True if enemy is facing right
var is_facing_right:bool = true

## Enemy state machine which handles switching of states
@onready var state_machine:Enemy_State_Machine = $Enemy_State_Machine
## Animated sprite
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	if disabled:
		process_mode = Node.PROCESS_MODE_DISABLED
	
	anim.play("idle")
	
	if not owner:
		return
	await owner.ready
	if owner.get_node("CanvasLayer/2D_Transition_Manager"):
		owner.get_node("CanvasLayer/2D_Transition_Manager").connect_enemy($DeathBox)


func _physics_process(delta):
	
	if state_machine.current_state:
		state_machine.current_state.physics_update(self, delta)
	
	if abs(velocity.x) - velocity.normalized().x * 300 * delta < 0:
		velocity.x = 0
	else:
		velocity.x -= velocity.normalized().x * 300 * delta
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	if not state_machine.current_state is Charge_Prep:
		if is_facing_right and velocity.x < 0:
			is_facing_right = false
			anim.flip_h = true
		elif not is_facing_right and velocity.x > 0:
			is_facing_right = true
			anim.flip_h = false
			
	var print_string = "%s %s %s %s %s %s " % [name, state_machine.current_state.name, velocity, targets, target, is_facing_right]
	#print(print_string)


func _process(delta):
	if state_machine.current_state:
		state_machine.current_state.update(self, delta)



func _on_detection_radius_body_entered(body):
	if body.is_in_group("Player"):
		targets.append(body)
		if not target_rays.has(body):
			var ray:RayCast2D = RayCast2D.new()
			ray.set_collision_mask_value(2, true)
			ray.hit_from_inside = true
			add_child(ray)
			target_rays[body] = ray


func _on_detection_radius_body_exited(body):
	if body.is_in_group("Player"):
		targets.erase(body)


func flee(body:RigidBody2D):
	#print("%s Flee" %name)
	state_machine.on_flee(body)
	
