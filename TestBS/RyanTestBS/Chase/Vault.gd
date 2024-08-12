extends Node3D


func _vault_prep_area_entered(body):
	if body is Chase_NPC:
		body.vault_prep = true


func _vault_body_entered(body):
	if body is Chase_NPC:
		body.vault($Height.global_position.y)
