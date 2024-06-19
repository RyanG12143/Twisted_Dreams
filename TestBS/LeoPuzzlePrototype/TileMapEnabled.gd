extends TileMap
## Changes TileMap being enabled or not.

@export var starting_enabled:bool = false

func _ready():
	set_layer_enabled(0, starting_enabled)

func disable():
	set_layer_enabled(0, false)

func enable():
	set_layer_enabled(0, true)
