extends GutTest

var Character = load("res://TestBS/LeoPuzzlePrototype/character.gd")
var world_scene = load("res://TestBS/MatthewTestBS/world.tscn")

func after_all():
	queue_free()

func test_passes():
	#Will pass because 1 = 1
	assert_eq(1,1)

func test_jump():
	var _character = Character.new()
	var sender = InputSender.new(_character)
	sender.action_down("ui_jump").wait_frames(1)
	await(sender.idle)
	assert_null(_character)
