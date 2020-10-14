extends Control



func _ready():
	$Music.value = Options.music_volume
	$Sound.value = Options.sound_volume

func _on_Music_value_changed(value):
	Options.music_volume = value
	Options.emit_signal("options_update")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)

func _on_Sound_value_changed(value):
	Options.sound_volume = value
	Options.emit_signal("options_update")
