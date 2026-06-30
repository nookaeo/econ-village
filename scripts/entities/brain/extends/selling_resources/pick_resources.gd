extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	if agent.global_position.distance_squared_to(agent.home.global_position) != 0:
		return Status.FAILURE
	for resource_id in agent.home.rule:
		if agent.home.house_storage[resource_id] * ItemData.items[resource_id]["weight"] - agent.home.house_storage_size * agent.home.rule[resource_id] < agent.weight_handle:
			continue
		blackboard.board["sell_resource"] = resource_id
		agent.add_item(resource_id,floori(agent.weight_handle / ItemData.items[resource_id]["weight"]))
		agent.home.remove_item(resource_id,floori(agent.weight_handle / ItemData.items[resource_id]["weight"]))
		return Status.SUCCESS
	return Status.FAILURE
