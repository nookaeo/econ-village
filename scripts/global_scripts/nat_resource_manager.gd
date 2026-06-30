extends Node

var bucket_size : float = 240
var grid = {}
var all_resources_by_name = {} # Local cache to avoid get_tree() in threads
var mutex : Mutex = Mutex.new()

func register_resource(node : Node2D, resource_name : String):
	var bucket_pos = Vector2i(node.global_position / bucket_size)
	
	mutex.lock()
	# 1. Update Spatial Grid
	if not grid.has(bucket_pos):
		grid[bucket_pos] = []
	grid[bucket_pos].append(node)
	
	# 2. Update Global List (Thread-safe alternative to get_nodes_in_group)
	if not all_resources_by_name.has(resource_name):
		all_resources_by_name[resource_name] = []
	all_resources_by_name[resource_name].append(node)
	mutex.unlock()

func unregister_resource(node : Node2D, resource_name : String):
	var bucket_pos = Vector2i(node.global_position / bucket_size)
	
	mutex.lock()
	# 1. Cleanup Spatial Grid
	if grid.has(bucket_pos):
		grid[bucket_pos].erase(node)
		if grid[bucket_pos].is_empty():
			grid.erase(bucket_pos)
			
	# 2. Cleanup Global List
	if all_resources_by_name.has(resource_name):
		all_resources_by_name[resource_name].erase(node)
	mutex.unlock()

func get_nearby_resources(search_pos : Vector2) -> Array:
	var center_bucket = Vector2i(search_pos / bucket_size)
	var nearby_nodes = []
	
	mutex.lock()
	for x in range(-1, 2):
		for y in range(-1, 2):
			var b_pos = center_bucket + Vector2i(x, y)
			if grid.has(b_pos):
				# We append to a local array while locked
				nearby_nodes.append_array(grid[b_pos])
	mutex.unlock()
	return nearby_nodes

func find_nearest_resource(agent: Node2D, resource_name : String):
	# SAFETY: Use local cache instead of get_tree().get_nodes_in_group()
	mutex.lock()
	var fallback_list = []
	if all_resources_by_name.has(resource_name):
		fallback_list = all_resources_by_name[resource_name].duplicate()
	mutex.unlock()
	
	if fallback_list.size() == 0:
		return null

	# Step 1: Check nearby grid first (Optimized)
	var raw_list = get_nearby_resources(agent.global_position)
	
	# Filter valid candidates (Thread-safe check)
	var candidates = raw_list.filter(func(n): 
		return is_instance_valid(n) and not n.is_queued_for_deletion()
	)
	
	var nearest_node = null
	var min_dist = INF 
	
	# Search nearby
	for node in candidates:
		if node.natural_resource_data.name != resource_name:
			continue
		if node.gatherer != null: # Assuming gatherer is a thread-safe property
			continue
			
		var dist = agent.global_position.distance_squared_to(node.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest_node = node
	
	# Step 2: Global Fallback if nothing is nearby
	if nearest_node == null:
		for node in fallback_list:
			if not is_instance_valid(node) or node.is_queued_for_deletion():
				continue
			if node.gatherer != null:
				continue
				
			var dist = agent.global_position.distance_squared_to(node.global_position)
			if dist < min_dist:
				min_dist = dist
				nearest_node = node
				
	return nearest_node
