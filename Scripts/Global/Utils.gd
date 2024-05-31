extends Node

# Created real file in computer
const SAVE_PATH = "res://savegame.bin"

func ready():
	#saveGame()
	loadGame()

func saveGame():
	# Write in temporary file
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	# Creating dictionary
	var data: Dictionary = {
		# Creating keys
		"curr_level": Game_State.curr_level,
	}
	# Converting to Json File
	# First stringify
	var jstr = JSON.stringify(data)
	# Second store
	file.store_line(jstr)
	
	
func loadGame():
	# Read in temporary file
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	# If the file exists
	if FileAccess.file_exists(SAVE_PATH) == true:
		# If not at end of file
		if not file.eof_reached():
			# parse string and read inside of JSON file
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game_State.curr_level = current_line["curr_level"]
