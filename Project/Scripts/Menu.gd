extends Control



func _ready():
	if not Music.playing:
		Music.play_track("menu")
