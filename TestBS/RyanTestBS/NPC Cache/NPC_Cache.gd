class_name NPC_Cache
extends Node

@export var Path_Civillian:PackedScene
@export var Path_Police:PackedScene
@export var Chase_Police:PackedScene

var civillian_cache:NPC
var police_cache:NPC
var chase_cache:Chase_NPC

func spawn_pathing_npc(type:Enums.NPC_TYPE)-> NPC:
	if type == Enums.NPC_TYPE.Civillian:
		var to_spawn:NPC = Path_Civillian.instantiate()
		to_spawn.visible = false
		if owner:
			owner.add_child(to_spawn)
		else:
			add_child(to_spawn)
		
		return to_spawn
	
	
	else:
		var to_spawn:NPC = Path_Police.instantiate()
		to_spawn.visible = false
		if owner:
			owner.add_child(to_spawn)
		else:
			add_child(to_spawn)
		
		return to_spawn


func despawn_pathing_npc(npc:NPC):
	pass
	
