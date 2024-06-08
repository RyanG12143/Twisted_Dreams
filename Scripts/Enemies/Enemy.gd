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
## If eneabled enemy will not leave platform
## [br]
## Does not handle flying
@export var grounded:bool = true

## Closest of the objects in targets
var target:CharacterBody2D
## Gets all player characters on ready and stores the node of each
var targets:Array[Node] = []

## Enemy state machine which handles switching of states
@onready var state_machine:State_Machine = $State_Machine




func _ready():
	pass


func _physics_process(delta):
	
	print(state_machine.current_state.name)
	print(targets)
	
	if state_machine.current_state:
		state_machine.current_state.physics_update(self, delta)
	
	if abs(velocity.x) - velocity.normalized().x * 300 * delta < 0:
		velocity.x = 0
	else:
		velocity.x -= velocity.normalized().x * 300 * delta
	velocity.y += GRAVITY * delta
	move_and_slide()


func _process(delta):
	if state_machine.current_state:
		state_machine.current_state.update(self, delta)



func _on_detection_radius_body_entered(body):
	if body.is_in_group("Player"):
		targets.append(body)


func _on_detection_radius_body_exited(body):
	if body.is_in_group("Player"):
		targets.erase(body)
