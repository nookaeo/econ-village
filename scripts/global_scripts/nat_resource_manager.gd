extends Node

var bucket_size :float = 320
var grid = {}

func register_resource(node :Node2D):
	var bucket_pos = Vector2i(node.global_position / bucket_size)
	if not grid.has(bucket_pos):
		grid[bucket_pos] = []
	grid[bucket_pos].append(node)

func unregister_resource(node :Node2D):
	var bucket_pos = Vector2i(node.global_position / bucket_size)
	if grid.has(bucket_pos):
		grid[bucket_pos].erase(node)
		if grid[bucket_pos].is_empty():
			grid.erase(bucket_pos)
	
func get_nearby_resources(search_pos :Vector2) -> Array:
	var center_bucket = Vector2i(search_pos / bucket_size)
	var nearby_nodes = []
	
	# Only check the current bucket and the 8 surrounding ones
	for x in range(-1, 2):
		for y in range(-1, 2):
			var b_pos = center_bucket + Vector2i(x, y)
			if grid.has(b_pos):
				nearby_nodes.append_array(grid[b_pos])
	return nearby_nodes
	
func find_nearest_resource(agent: Node2D,resource_name :String):
	var all_resource = get_tree().get_nodes_in_group(resource_name)
	if all_resource.size() == 0 :
			return
	var raw_list = NatResourceManager.get_nearby_resources(agent.home.global_position).duplicate()
	var candidates = raw_list.filter(func(n): 
		return is_instance_valid(n) and not n.is_queued_for_deletion()
	)
	var nearest_node = null
	var min_dist_1 = INF 
	var min_dist_2 = INF 
	
	for node :NaturalResource in candidates:
		
		if not is_instance_valid(node) or node.is_queued_for_deletion():
			continue
		if node.natural_resource_data.name != resource_name:
			continue
		if node.gatherer != null:
			continue
		var dist = agent.global_position.distance_squared_to(node.global_position)
		if dist < min_dist_1:
			min_dist_1 = dist
			nearest_node = node
	
	if nearest_node == null:
		for node :NaturalResource in all_resource:
			var dist = agent.global_position.distance_squared_to(node.global_position)
			if not is_instance_valid(node) or node.is_queued_for_deletion():
				continue
			if node.gatherer != null:
				continue
			if dist < min_dist_2:
				min_dist_2 = dist
				nearest_node = node
		
	return nearest_node
