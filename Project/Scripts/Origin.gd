extends Node2D

var circle_active = false

func _draw():
	if circle_active:
		draw_arc(get_local_mouse_position(), 200, 0, deg2rad(360), 100, Color.white)
