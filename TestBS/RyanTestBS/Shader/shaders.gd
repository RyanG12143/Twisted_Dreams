extends Node

var building_saturation:ShaderMaterial
var plant_saturation:ShaderMaterial

const DESATURATED:int = .2
const SATRUATED:int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("swap_shaders"):
		swap_shader_saturation()

func set_shaders(building, plant):
	building_saturation = building
	plant_saturation = plant
	plant_saturation.set_shader_parameter("saturation", .2)

func swap_shader_saturation():
	if plant_saturation.get_shader_parameter("saturation") == 1:
		plant_saturation.set_shader_parameter("saturation", .2)
	else:
		plant_saturation.set_shader_parameter("saturation", 1)
		
	if building_saturation.get_shader_parameter("saturation") == 1:
		building_saturation.set_shader_parameter("saturation", .2)
	else:
		building_saturation.set_shader_parameter("saturation", 1)
