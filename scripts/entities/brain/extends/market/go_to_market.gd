extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	if not get_tree().get_first_node_in_group("Market"):
		return Status.FAILURE
	blackboard.board["market"] = get_tree().get_first_node_in_group("Market")
	if not blackboard.board.has("market"):
		return Status.FAILURE
	agent._move_to_grid(agent.tile_map.local_to_map(blackboard.board["market"].global_position))
	
	if agent.global_position.distance_squared_to(blackboard.board["market"].global_position) == 0:
		return Status.SUCCESS
		
	return Status.RUNNING
