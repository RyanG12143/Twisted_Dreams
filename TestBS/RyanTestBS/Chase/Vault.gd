extends Node3D


func _vault_body_entered(body):
	if body is Chase_NPC:
		body.vault($Height.global_position.y, global_position - $Direction.global_position)
