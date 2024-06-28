extends GutTest

var character1 = preload("uid://m23ls6buacwh")
var character2 = preload("uid://pqhyjjoo1fcs")
var enemy = preload("uid://yt3boj0lw4yf")

var enemy_roam_scene = preload("uid://b01vxnikm6goy")

func test_roam():
	var main = autofree(enemy_roam_scene.instantiate())
	add_child(main)
	var enemy_list:Array = get_tree().get_nodes_in_group("Enemy")
	
	for ene in enemy_list:
		assert_is(ene.state_machine.current_state, Follow, "Defualt state is follow")
	await get_tree().create_timer(.1).timeout
	for ene in enemy_list:
		assert_is(ene.state_machine.current_state, Roaming, "Should switch to roam as there are no characters")
	await get_tree().create_timer(1).timeout
	for ene in enemy_list:
		assert_is(ene.state_machine.current_state, Roaming, "Should never switch from roam")
		assert_false(ene.is_facing_right, "Hit the edge of platform")
	await get_tree().create_timer(1).timeout
	for ene in enemy_list:
		assert_is(ene.state_machine.current_state, Roaming, "Should never switch from roam")
		assert_true(ene.is_facing_right, "Hit the edge of platform")
