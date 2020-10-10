extends Area2D

const SPEED = 10

var friendly
var direction = Vector2()

func start(dir, friendly_):
	friendly = friendly_
	if not friendly:
		modulate = Color.blue
	direction = dir
	look_at(dir + position)

func _physics_process(delta):
	position += direction * SPEED

func left_screen():
	queue_free()

func hit(body):
	if body.has_method("switch_alliance"):
		if (body.alliance == body.Alliance.ALLY) != friendly:
			body.switch_alliance()
			hack()
	if body.name == "Player":
		if not friendly:
			pass

func hack():
	queue_free()
