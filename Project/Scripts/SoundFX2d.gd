extends AudioStreamPlayer2D



func _ready():
	update_db()
	Options.connect("options_update", self, "options_updated")

func options_updated():
	update_db()

func update_db():
	var scalable_db = -80.0 - volume_db
	var subtracted_db = scalable_db * (1.0 - Options.sound_volume)
	volume_db -= subtracted_db
