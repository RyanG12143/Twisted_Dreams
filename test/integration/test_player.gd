extends GutTest

var World = load('res://test/testing_scene.tscn')

var _world = null
var _player = null
var _sender = InputSender.new(Input)

func before_each():
	_world = add_child_autofree(World.instantiate())
	_player = _world.get_node('character_one')
	wait_frames(10)
	
func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'Should exist')

func test_jump():
	_sender.action_down("ui_jump").hold_for(1)
	await(_sender.idle)
