extends KinematicBody2D

signal chain_reaction

enum State {SEARCHING, ATTACKING}
enum Alliance {ENEMY, ALLY}

const BULLET = preload("res://Scenes/Bullet.tscn")
const SPEED = 200

var state = State.SEARCHING
var alliance = Alliance.ENEMY
var target = null
var direction = Vector2()
var move = 1
var can_shoot = true
var controlling = []
var controlled_by = null

func _draw():
	for body in controlling:
		draw_line(Vector2(), body.position - position, Color.white)

func _process(delta):
	update()

func _physics_process(delta):
	if state == State.SEARCHING:
		move_and_slide((SPEED / 2) * direction)
	else:
		attack()
		move_and_slide(SPEED * direction * move)

func attack():
	if position.distance_to(target.position) <= 150:
		move = 0
	else:
		move = 1
	if $Sprite.animation != "run" and move == 1:
		$Sprite.play("run")
	elif move == 0:
		$Sprite.play("idle")
	if (direction * move).x < 0:
		$Sprite.flip_h = true
	elif (direction * move).x > 0:
		$Sprite.flip_h = false
	direction = (target.position - position).normalized() * move
	
	if target.has_method("switch_alliance"):
		if target.alliance == alliance:
			target = get_target()
	elif target.name == "Player" and alliance == Alliance.ALLY:
		target = get_target()
	
	shoot_attempt()

func shoot_attempt():
	if target != null:
		if can_shoot:
			shoot()
		elif $Cooldown.time_left == 0:
			$Cooldown.start()

func shoot():
	can_shoot = false
	var b = BULLET.instance()
	get_parent().add_child(b)
	b.position = position
	if alliance == Alliance.ALLY:
		b.start((target.position - position).normalized(), true, self)
	else:
		b.start((target.position - position).normalized(), false, null)

func wander():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_dir = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)).normalized()
	direction = new_dir

func _on_TargetFinder_body_entered(body):
	if target == null:
		target = get_target()
		if target != null:
			state = State.ATTACKING

func _on_Wander_timeout():
	if state == State.SEARCHING:
		wander()

func _on_TargetFinder_body_exited(body):
	if body == target:
		target = get_target()
		#if target == null:
			#state = State.SEARCHING

func get_target():
	var bodies = $TargetFinder.get_overlapping_bodies()
	var targets = []
	#bodies.remove(bodies.find(target))
	if bodies.size() > 0:
		for body in bodies:
			if viable_target(body):
				targets.append(body)
	if targets.size() > 0:
		state = State.ATTACKING
		return targets[0]
	else:
		state = State.SEARCHING
		return null

func viable_target(body):
	if body.name == "Player":
		return alliance == Alliance.ENEMY
	elif body.has_method("switch_alliance"):
		return body.alliance != alliance
	else:
		return false

func switch_alliance(branch_cut = false):
	if alliance == Alliance.ENEMY and not branch_cut:
		alliance = Alliance.ALLY
	else:
		if controlled_by != null:
			controlled_by.controlling.remove(controlled_by.controlling.find(self))
		for body in controlling:
			if body.alliance == Alliance.ALLY and body != self:
				body.switch_alliance(true)
				print(str(self) + " called switch alliance on " + str(body))
		controlling.clear()
		alliance = Alliance.ENEMY
		
	target = get_target()
	if alliance == Alliance.ALLY:
		modulate = Color(1, 0, 0, 1)
	else:
		modulate = Color.white

func _on_Cooldown_timeout():
	can_shoot = true
