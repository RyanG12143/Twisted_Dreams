extends Marker3D

@export_group("Spawn Path NPC")
@export var path_spawn:bool
@export var type:Enums.NPC_TYPE
@export var path:Node3D
@export var loop:bool
@export var inverse_loop:bool
@export var observe:bool
@export var free_on_end:bool = true
@export var wait_on_spawn:bool
@export var wait_time:float


@onready var cache:NPC_Cache = %NPC_Cache

func spawn():
	
	var spawn_npc:= cache.spawn_pathing_npc(type)
	spawn_npc.positions_container = path
	spawn_npc.loop = loop
	spawn_npc.inverse_loop = inverse_loop
	spawn_npc.observe = observe
	spawn_npc.free_on_end = free_on_end
	
	spawn_npc.process_mode = Node.PROCESS_MODE_INHERIT
	spawn_npc.global_position = global_position
	spawn_npc.visible = true
	
	if spawn_npc.is_node_ready():
		spawn_npc.ready()
		
		if wait_on_spawn:
			spawn_npc.wait(wait_time)
	else:
		await spawn_npc.ready
		if wait_on_spawn:
			spawn_npc.wait(wait_time)
