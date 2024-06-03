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

## Closest of the objects in _targets
var target:CharacterBody2D

## Gets all player characters on ready and stores the node of each
var _targets:Array[Node] = []

## Nav agent for enemy
@onready var nav:NavigationAgent2D = $NavigationAgent2D
## Enemy state machine which handles switching of states
@onready var state_machine:State_Machine = $State_Machine




func _ready():
	nav.target_position = global_position
	
	if owner and owner.is_node_ready():
		_targets = get_tree().get_nodes_in_group("Player")
		_on_timer_timeout()
	elif(owner):
		await owner.ready
		_targets = get_tree().get_nodes_in_group("Player")
		_on_timer_timeout()


func _physics_process(delta):
	
	if target:
		nav.target_position = target.global_position
	
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


## Redetermines target every second or when called
func _on_timer_timeout():
	if not _targets:
		return
	if not target:
		target = _targets[0]
	for tar in _targets:
		if position.distance_to(tar.position) < position.distance_to(target.position):
			target = tar
