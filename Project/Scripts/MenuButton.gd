extends Button

export (String) var next_scene

func _on_mouse_entered():
	$Animation.play("hover")
	$FX.play()

func _on_mouse_exited():
	$Animation.play("_hover")

func _on_pressed():
	get_tree().change_scene(next_scene)
