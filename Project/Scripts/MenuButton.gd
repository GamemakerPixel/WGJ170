extends Button

export (String) var next_scene = ""

func _on_mouse_entered():
	if not disabled:
		$Animation.play("hover")
		$FX.play()

func _on_mouse_exited():
	if not disabled:
		$Animation.play("_hover")

func _on_pressed():
	print(next_scene)
	get_tree().change_scene(next_scene)
