extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	var market :Market = get_tree().get_first_node_in_group("Market")
		
	agent._move_to_grid(agent.tile_map.local_to_map(market.global_position))
	
	if agent.global_position.distance_squared_to(market.global_position) == 0:
		market.signin_market_id(agent)
		return Status.SUCCESS
		
	return Status.RUNNING
