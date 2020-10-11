extends CanvasLayer

var points = 0
var friendliness = 0

func _process(delta):
	$Friendly.text = str(get_friendliness()) + "% Friendly"

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
	while chains.size() > 0:
		for chain in chains:
			chain_sizes.append(get_chain_length(chain))
	print(chain_sizes)

func get_chain_length(chain):
	#var length = 1
	#if chain.controlling.size() > 0:
		#length += get_subchain(chain)
	#else:
		#return length
	return 1

func get_subchain(subchain):
	var subchain_length = 1
	for branch in subchain.controlling:
		if branch.controlling.size() > 0:
			for twig in branch.controlling:
				subchain_length += get_subchain(twig)
		else:
			subchain_length += 1
	return subchain_length
