extends KinematicBody2D

const SPEED = 175
const BULLET = preload("res://Scenes/Bullet.tscn")
const ARROW_TEXTURE = preload("res://Art/Temp/Cursor.png")

export (Gradient) var health_gradient

var can_shoot = true

var velocity = Vector2()
onready var health = $UI/Health.max_value

func _ready():
	update_health(0)
	Input.set_custom_mouse_cursor(load("res://Art/Temp/Cursor.png"), Input.CURSOR_ARROW)

func _draw():
	for child in get_parent().get_children():
		if child.has_method("switch_alliance"):
			if child.alliance == 0:
				var dir = (child.position - position).normalized()
				draw_texture(ARROW_TEXTURE, dir * 200)

func _physics_process(delta):
	update()
	$CollisionPolygon2D.position = Vector2()
	if Input.is_action_pressed("shoot") and can_shoot and not ($Powerups.menu_open or $Powerups.range_circle_active):
		shoot()
		can_shoot = false
		$Cooldown.start()
	if Input.is_action_pressed("shoot_against") and can_shoot:
		shoot(false)
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
	health += amount
	if health > 100:
		health = 100
	$UI/Health.value = health
	$UI/Health.modulate = health_gradient.interpolate(float(health) / float($UI/Health.max_value))
	if health <= 0:
		print("!! GAME OVER !!")

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
