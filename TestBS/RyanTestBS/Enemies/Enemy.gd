extends CharacterBody2D

# Private Globals
var at_target:bool = false
var selected:bool = false
var targets:Array[Node] = []
var target:CharacterBody2D
const GRAVITY:float = 1200

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var state_machine:State_Machine = $State_Machine

# Exported
@export var SPEED:float = 2000.0


func _ready():
	nav.target_position = global_position
	
	if owner and owner.is_node_ready():
		targets = get_tree().get_nodes_in_group("Player")
		_on_timer_timeout()
	elif(owner):
		await owner.ready
		targets = get_tree().get_nodes_in_group("Player")
		_on_timer_timeout()


func _physics_process(delta):
	if target:
		nav.target_position = target.global_position
	
	if nav.target_position.distance_to(global_position) > nav.target_desired_distance:
		_path_changed()
	
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
		state_machine.current_state.update(self)


func _target_reached():
	at_target = true


func _path_changed():
	at_target = false


func _on_timer_timeout():
	if not targets:
		return
	if not target:
		target = targets[0]
	for tar in targets:
		if position.distance_to(tar.position) < position.distance_to(target.position):
			target = tar
