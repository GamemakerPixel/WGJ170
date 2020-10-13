extends Particles2D


func run():
	$Crt.play("run")

func _on_Crt_animation_finished(_anim_name):
	queue_free()
