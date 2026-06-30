extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	
	if agent.global_position.distance_squared_to(blackboard.board["market"].global_position) == 0:
		blackboard.board["market"].sign_market_id(agent)
		agent.market_data.assign(blackboard.board["market"].get_information())
		return Status.SUCCESS
		
	return Status.FAILURE
