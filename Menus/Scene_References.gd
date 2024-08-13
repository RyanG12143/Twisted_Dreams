extends Node
## Stores references to scenes (mainly used for menu traversal & loading levels from the play menu).

var game_opened:String = ("uid://r23b5ipm0uji")
var main_menu:String = ("uid://baapsc4104dfh")
var play_menu:String= ("uid://bq3sv75y8346j")
var settings_menu:String = ("uid://b2bml8s2sr1x2")
var brother_select:String = ("uid://cepsbxuhi02i5")

var stored_scene:String = ""

var level_dict:Dictionary = {
	"Dream Level 1": ("uid://cyn2r4owpmtan"),
	"Real Level 1": ("uid://cq62xwmqwdoot"),
 }

## Stores the 3D levels
var level_dict_3D:Dictionary = {
	"Home District": ("uid://cq62xwmqwdoot"),
	"Market District": ("uid://dre0o1tw818oq"),
}
