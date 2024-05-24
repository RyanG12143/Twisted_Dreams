extends Node

var building_saturation:Array[ShaderMaterial]
var plant_saturation:Array[ShaderMaterial]

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
	for p in plant_saturation:
		p.set_shader_parameter("saturation", .2)

func swap_shader_saturation():
	if plant_saturation[0].get_shader_parameter("saturation") == 1:
		for p in plant_saturation:
			p.set_shader_parameter("saturation", .2)
	else:
		for p in plant_saturation:
			p.set_shader_parameter("saturation", 1)
		
	if building_saturation[0].get_shader_parameter("saturation") == 1:
		for b in building_saturation:
			b.set_shader_parameter("saturation", .2)
	else:
		for b in building_saturation:
			b.set_shader_parameter("saturation", 1)
