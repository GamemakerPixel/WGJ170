extends Area2D

const SPEED = 10

var friendly
var direction = Vector2()
var shot_by = null

func start(dir, friendly_, shot_by_ = null):
	friendly = friendly_
	direction = dir
	look_at(dir + position)
	shot_by = shot_by_
	load_graphics()
	
	randomize()
	var fx_pitch = float(randi() % 50 + 100) / 100.0
	$FX.pitch_scale = fx_pitch
	$FX.play()

func load_graphics():
	if not friendly:
		$Sprite.play("enemy")
		$Sprite/Particles2D.process_material = load("res://Resources/Particles/EnemyBullet.tres")
		$Explode.process_material = load("res://Resources/Particles/EnemyExplode.tres")

func _physics_process(delta):
	if not get_parent().paused:
		position += direction * SPEED

func left_screen():
	queue_free()

func hit(body):
	if body.has_method("switch_alliance"):
		if (body.alliance == body.Alliance.ALLY) != friendly:
			if body.alliance == body.Alliance.ENEMY and shot_by != null:
				if shot_by.alliance == body.Alliance.ALLY:
					shot_by.controlling.append(body)
					body.controlled_by = shot_by
			body.switch_alliance()
			hack()
	if body.name == "Player" and not friendly:
		body.update_health(-1)
		hack()

func hack():
	print("EXPLODE")
	$CollisionShape2D.disabled = true
	direction = Vector2()
	$Explode.emitting = true
	$ExplodeTime.start()
	$Sprite.hide()

func _on_ExplodeTime_timeout():
	queue_free()
