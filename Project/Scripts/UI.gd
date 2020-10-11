extends CanvasLayer

var points = 600
var stat_data = [0, 0, 0]

func _process(delta):
	stat_data[0] = get_friendliness()
	stat_data[1] = get_stability()
	stat_data[2] = 100.0 * ((stat_data[0]/100.0) * (stat_data[1]/100.0))
	$Friendly.text = str(stat_data[0]) + "% Friendly"
	$Stability.text = str(stat_data[1]) + "% Stable"
	$Control.text = str(stat_data[2]) + "% Total Control"

func add_point():
	points += 1
	$Points.text = str(points) + " Points"

func get_friendliness():
	var allies = 0
	var enemies = 0
	var percent = 0
	for node in get_parent().get_parent().get_children():
		if node.has_method("switch_alliance"):
			if node.alliance == 0:
				enemies += 1
			else:
				allies += 1
	allies = float(allies)
	enemies = float(enemies)
	if allies + enemies > 0:
		percent = round(100.0 * (allies / (allies + enemies)))
	return percent

func get_stability():
	var stability_percent = 0
	var chain_sizes = []
	var chains = []
	for node in get_parent().get_parent().get_children():
		if node.has_method("switch_alliance"):
			if node.alliance == 1 and node.controlled_by == null:
				chains.append(node)
	for chain in chains:
		chain_sizes.append(chain.count_controlled() + 1)
	
	var average = average_denominator(chain_sizes)
	stability_percent = round(average * 100.0)
	return stability_percent

func average_denominator(data:Array):
	var sum = 0.0
	var count = data.size()
	var average = 0.0
	for value in data:
		sum += 1.0/float(value)
	if count != 0:
		average = sum/float(count)
	return average
