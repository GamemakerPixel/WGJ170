extends AudioStreamPlayer

const PATH = "res://Audio/Music/"
const SUFFIX = ".ogg"

func _ready():
	connect("finished", self, "loop")
	Options.connect("options_update", self,"options_updated")

func play_track(track_name:String):
	stream = load(PATH + track_name + SUFFIX)
	play()

func loop():
	play()

func options_updated():
	var scalable_db = -80.0 - volume_db
	var subtracted_db = scalable_db * (1.0 - Options.music_volume)
	volume_db -= subtracted_db
