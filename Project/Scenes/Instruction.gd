extends Control

const SLIDES = ["A", "B", "C", "D", "E"]
var index = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Animations.play(SLIDES[index] + SLIDES[index+1])
		index += 1

func _on_Animations_animation_finished(anim_name):
	if anim_name == "DE":
		get_tree().change_scene("res://Scenes/World.tscn")
