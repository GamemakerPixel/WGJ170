extends Area2D

const SPEED = 10

var friendly
var direction = Vector2()
var shot_by = null

func start(dir, friendly_, shot_by_ = null):
	friendly = friendly_
	if not friendly:
		modulate = Color.blue
	direction = dir
	look_at(dir + position)
	shot_by = shot_by_

func _physics_process(delta):
	position += direction * SPEED

func left_screen():
	queue_free()

func hit(body):
	if body.has_method("switch_alliance"):
		if (body.alliance == body.Alliance.ALLY) != friendly:
			if body.alliance == body.Alliance.ENEMY and shot_by != null:
				shot_by.controlling.append(body)
				body.controlled_by = shot_by
			body.switch_alliance()
			hack()
	if body.name == "Player":
		if not friendly:
			pass

func hack():
	queue_free()
