extends Node3D

@export var building_saturation:ShaderMaterial
@export var plant_saturation:ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	Shaders.set_shaders(building_saturation, plant_saturation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


