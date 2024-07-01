extends GutTest

var Character = load("res://TestBS/LeoPuzzlePrototype/character.gd")
var world_scene = load("res://TestBS/MatthewTestBS/world.tscn")

func after_all():
	queue_free()

func test_passes():
	#Will pass because 1 = 1
	assert_eq(1,1)
