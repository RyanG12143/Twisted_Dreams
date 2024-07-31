extends Node2D

func _on_master_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0 , value - 80)


func _on_master_volume_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1 , value - 80)


func _on_music_volume_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(1, toggled_on)


func _on_effects_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2 , value - 80)


func _on_effects_volume_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(2, toggled_on)


func _on_dialogue_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(3 , value - 80)


func _on_dialogue_volume_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(3, toggled_on)
