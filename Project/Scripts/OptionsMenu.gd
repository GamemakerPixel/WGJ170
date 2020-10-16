extends Control



func _ready():
	$Music.value = -((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))/-80.0) - 1.0)
	$Sound.value = -((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))/-80.0) - 1.0)

func _on_Music_value_changed(value):
	var subtracted_db = -80.0 * (1.0 - value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), subtracted_db)

func _on_Sound_value_changed(value):
	var subtracted_db = -80.0 * (1.0 - value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), subtracted_db)
