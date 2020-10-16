extends LinkButton

const LINK = "https://youtube.com/c/GamemakerPixel"

func _mouse_entered():
	$Animation.play("hover")
	$FX.play()

func _mouse_exited():
	$Animation.play("_hover")

func _on_Youtube_pressed():
	OS.shell_open(LINK)
