extends Node3D

var avg = 0
var thing:Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	thing.append(1/delta)
	avg += (1/delta)/60
	if thing.size() > 60:
		
		avg -= thing.pop_front()/60
	print(avg)
