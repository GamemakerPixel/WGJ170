extends CanvasLayer

enum Power {LINK_BREAK, AOE}

const IMAGE = preload("res://Art/Powerups.png")
const power_cost = [500, 200]

var menu_open = false
var power_position = []
var range_circle_active = false

func _process(delta):
	if Input.is_action_just_pressed("powerup"):
		if not menu_open:
			open_menu()
		else:
			$PowerCenter.hide()
			menu_open = false
	if range_circle_active:
		$Origin.circle_active = true
		$Origin.update()
		if Input.is_action_just_pressed("shoot"):
			var ais = get_all_AI()
			for ai in ais:
				if ai.alliance == ai.Alliance.ENEMY:
					if get_parent().get_parent().get_position_from_world_mouse(ai.position) <= 200:
						ai.switch_alliance()
			range_circle_active = false
			$Origin.circle_active = false
			$Origin.update()
	if menu_open:
		for power in range($PowerCenter.get_child_count()):
			var node = $PowerCenter.get_children()
			node = node[power-1]
			if node.texture.region.position.x != 64:
				if power_cost[power-1] <= get_parent().get_node("UI").points:
					node.texture.region.position.x = 32
				else:
					node.texture.region.position.x = 0
		
		var closest_power = null
		var mouse_pos = $PowerCenter.get_local_mouse_position()
		for power in power_position:
			if closest_power == null:
				closest_power = power
			else:
				var distance_to = power.distance_to(mouse_pos)
				var closest_dis_to = closest_power.distance_to(mouse_pos)
				if distance_to < closest_dis_to:
					closest_power = power
		highlight_power(closest_power)
		
		if Input.is_action_just_pressed("shoot"):
			$PowerCenter.hide()
			menu_open = false
			var power
			var children = $PowerCenter.get_children()
			var children_pos = []
			for child in children:
				children_pos.append(child.position)
			power = children_pos.find(closest_power)
			activate_power(power)
		
		closest_power = null

func activate_power(power):
	if power == Power.LINK_BREAK:
		for ai in get_all_AI():
			if ai.alliance == ai.Alliance.ALLY:
				if randi() % 2 == 1:
					for _ai in ai.controlling:
						_ai.controlled_by = null
					ai.controlling.clear()
	if power == Power.AOE:
		range_circle_active = true
		for ai in get_all_AI():
			pass
	get_parent().get_node("UI").points -= (power_cost[power]) + 1
	get_parent().get_node("UI").add_point()

func get_all_AI():
	var ais = []
	for child in get_parent().get_parent().get_children():
		if child.has_method("switch_alliance"):
			ais.append(child)
	return ais

func highlight_power(power):
	var power_texture = $PowerCenter.get_child(power_position.find(power)).texture
	var other_nodes = $PowerCenter.get_children()
	other_nodes.remove(other_nodes.find($PowerCenter.get_child(power_position.find(power))))
	for node in other_nodes:
		if node.texture.region.position.x != 0:
			node.texture.region.position.x = 32
	if power_texture.region.position.x != 0:
		power_texture.region.position.x = 64
	
	

func open_menu():
	menu_open = true
	$PowerCenter.position = $Origin.get_local_mouse_position()
	if $PowerCenter.get_child_count() == 0:
		create_menu()
	power_position.clear()
	for child in $PowerCenter.get_children():
		power_position.append(child.position)
	$PowerCenter.show()

func create_menu():
	var height = IMAGE.get_height()
	var count = height / 32
	for power in range(count):
		var texture = AtlasTexture.new()
		texture.atlas = IMAGE
		texture.region = Rect2(Vector2(0, power * 32), Vector2(32, 32))
		
		var sprite = Sprite.new()
		$PowerCenter.add_child(sprite)
		sprite.texture = texture
		sprite.scale = Vector2(2, 2)
		
		var individual_rot = 360.0 / float(count)
		sprite.position = Vector2(0, 75).rotated(deg2rad(individual_rot * (power - 1)))
		power_position.append(sprite.position)
	
