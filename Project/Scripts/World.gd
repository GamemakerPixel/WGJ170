extends Node2D

const ENEMY = preload("res://Scenes/Enemy.tscn")

func spawn_enemy():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var e = ENEMY.instance()
	add_child(e)
	var new_pos = Vector2()
	var rand_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	var rand_dis = rng.randi_range(250, 450)
	new_pos = rand_dir * rand_dis
	e.position = new_pos
	$SpawnCooldown.wait_time /= 1.01
	if $SpawnCooldown.wait_time < 0.1:
		$SpawnCooldown.wait_time = 0
	$SpawnCooldown.start()

func get_position_from_world_mouse(position_):
	return get_local_mouse_position().distance_to(position_)
