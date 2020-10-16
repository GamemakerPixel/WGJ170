extends AudioStreamPlayer

const PATH = "res://Audio/Music/"
const SUFFIX = ".ogg"

func _ready():
	connect("finished", self, "loop")
	bus = "Music"

func play_track(track_name:String):
	stream = load(PATH + track_name + SUFFIX)
	play()

func loop():
	play()

