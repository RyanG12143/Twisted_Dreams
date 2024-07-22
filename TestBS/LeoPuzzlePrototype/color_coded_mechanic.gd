extends AnimatedSprite2D
class_name ColorCodedMechanic
## Abstract parent that allows mechanics which inherit it to easily be color-coded.

## List of selectable colors
@export_enum("blue", "pink" , "orange") var color:String = "blue"
