extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	if agent.global_position.distance_squared_to(agent.home.global_position) == 0:
		agent.home.market_data.assign(agent.market_data)
		#print(agent.home.market_data)
		blackboard.board["market_updated"] = true
		return Status.SUCCESS
	
	return Status.FAILURE
