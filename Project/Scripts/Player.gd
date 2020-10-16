extends KinematicBody2D

const SPEED = 175
const BULLET = preload("res://Scenes/Bullet.tscn")
const ARROW_TEXTURE = preload("res://Art/Enemy Warning.png")

export (Gradient) var health_gradient

var can_shoot = true

var velocity = Vector2()
onready var health = $UI/Health.max_value

var dead = false

func _ready():
	update_health(0)
	Input.set_custom_mouse_cursor(load("res://Art/Cursor4.png"), Input.CURSOR_ARROW)
	$HitParticles.emitting = false
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game Sound"), 0.0)
	$Locator/Animation.play("locate")

func _draw():
	for child in get_parent().get_children():
		if child.has_method("switch_alliance"):
			if child.alliance == 0:
				var dir = (child.position - position).normalized()
				draw_texture(ARROW_TEXTURE, dir * 200)

func _physics_process(delta):
	update()
	if Input.is_action_just_pressed("ui_cancel"):
		if $PauseScreen/Control.modulate == Color(1, 1, 1, 0):
			$PauseScreen/Control/Animation.play("show")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game Sound"), -80.0)
			get_parent().paused = true
		else:
			$PauseScreen/Control/Animation.play("hide")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game Sound"), 0.0)
			Engine.time_scale = 1
			get_parent().paused = false
		$Pause.play()
	if not get_parent().paused:
		$CollisionPolygon2D.position = Vector2()
		if Input.is_action_pressed("shoot") and can_shoot and not ($Powerups.menu_open or $Powerups.range_circle_active):
			shoot()
			can_shoot = false
			$Cooldown.start()
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
		else:
			velocity.x = 0
		if Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
		elif Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
		else:
			velocity.y = 0
		update_visuals()
	move_and_slide(velocity)

func update_health(amount:int):
	if amount < 0:
		$Hit.play()
		run_hit_particles()
	health += amount
	if health > 100:
		health = 100
	$UI/Health.value = health
	$UI/Health.modulate = health_gradient.interpolate(float(health) / float($UI/Health.max_value))
	if health <= 0 and not dead:
		if not $Defeat.playing:
			dead = true
			$Defeat.play()
			$DefeatScreen/Control/Animation.play("show")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game Sound"), -80.0)

func shoot(alliance = true):
	var dir = get_local_mouse_position().normalized()
	var b = BULLET.instance()
	get_parent().add_child(b)
	b.position = position
	b.start(dir, alliance)

func update_visuals():
	if velocity == Vector2():
		$Sprite.play("idle")
	elif $Sprite.animation == "idle":
		$Sprite.play("run")
	if velocity.x < 0:
		$Sprite.flip_h = true
	elif velocity.x > 0:
		$Sprite.flip_h = false

func _on_Cooldown_timeout():
	can_shoot = true

func run_hit_particles():
	var p = load("res://Scenes/Effects/HitParticles.tscn").instance()
	add_child(p)
	p.run()
