extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready():
	bake_navigation_polygon()
	navigation_polygon_changed.connect(_update_polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_polygon():
	bake_navigation_polygon()
