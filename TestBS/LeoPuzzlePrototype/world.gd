extends Node2D
## Resets globals values when a level is loaded/reloaded.

func _ready():
	globals.reset_values()
