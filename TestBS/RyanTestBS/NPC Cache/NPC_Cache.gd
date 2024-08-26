class_name NPC_Cache
extends Node

@export_group("Scenes")
@export var Path_Civillian:PackedScene
@export var Path_Police:PackedScene
@export var Chase_Police:PackedScene

@export_group("Preloading")
@export var number_preload_path_civillian:int = 0
@export var number_preload_path_police:int = 0
@export var number_preload_chase_police:int = 0

var civillian_cache:Array[NPC] = []
var police_cache:Array[NPC] = []
var chase_cache:Array[Chase_NPC] = []


func _ready():
	while civillian_cache.size() < number_preload_path_civillian:
		var to_spawn = Path_Civillian.instantiate()
		to_spawn.visible = false
		to_spawn.npc_cache = self
		
		if owner:
			owner.add_child(to_spawn)
		else:
			add_child(to_spawn)
		
		despawn_pathing_npc(to_spawn)
	
	while police_cache.size() < number_preload_path_police:
		var to_spawn = Path_Police.instantiate()
		to_spawn.visible = false
		to_spawn.npc_cache = self
		
		if owner:
			owner.add_child(to_spawn)
		else:
			add_child(to_spawn)
		
		despawn_pathing_npc(to_spawn)


func _process(delta):
	print(get_tree().get_nodes_in_group("Police").size())


func spawn_pathing_npc(type:Enums.NPC_TYPE)-> NPC:
	if type == Enums.NPC_TYPE.Civillian:
		var to_spawn:NPC
		
		if civillian_cache:
			to_spawn = civillian_cache.pop_back()
		else:
			to_spawn = Path_Civillian.instantiate()
			to_spawn.visible = false
			to_spawn.npc_cache = self
		
		if owner:
			owner.add_child(to_spawn)
		else:
			add_child(to_spawn)
		
		return to_spawn
	
	
	else:
		var to_spawn:NPC
		
		if police_cache:
			to_spawn = police_cache.pop_back()
		else:
			to_spawn = Path_Police.instantiate()
			to_spawn.visible = false
			to_spawn.npc_cache = self
		
		if owner:
			owner.add_child(to_spawn)
		else:
			add_child(to_spawn)
		
		return to_spawn


func despawn_pathing_npc(npc:NPC):
	if npc.is_in_group("Police"):
		police_cache.append(npc)
	else:
		civillian_cache.append(npc)
	
	npc.process_mode = Node.PROCESS_MODE_DISABLED
	npc.global_position = Vector3(0,-1000,0)
	npc.visible = false
	
	npc.positions_container = null
	npc.loop = false
	npc.inverse_loop = false
	npc.observe = false
	npc.free_on_end = false
