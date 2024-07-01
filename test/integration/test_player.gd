extends GutTest

var World = load('res://test/testing_scene.tscn')

var _world = null
var _player = null
var _sender = InputSender.new(Input)

func before_each():
	_world = add_child_autofree(World.instantiate())
	_player = _world.get_node('character_one')
	await wait_frames(5)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'Should exist')
	assert_true(_player.is_on_floor(), 'Should be on floor')

func test_jump():
	assert_eq(_player.velocity.y, 0.0)
	_sender.action_down("ui_jump").hold_for(1)
	await(_sender.idle)
	assert_gt(_player.velocity.y, 0.0, 'Velocity should be more than 0')

func test_movement_right():
	assert_eq(_player.position.x, 302.0, 'Starting position')
	_sender.key_down("d").hold_for(1)
	await(_sender.idle)
	assert_gt(_player.position.x, 302.0, 'Should be further right')

func test_movement_left():
	assert_eq(_player.position.x, 302.0, 'Starting position')
	_sender.key_down("a").hold_for(1)
	await(_sender.idle)
	assert_lt(_player.position.x, 302.0, 'Should be further left')
