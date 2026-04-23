extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	if not is_instance_valid(blackboard.board["target"]):
		return Status.FAILURE
	if blackboard.board["target"].gatherer != null :
		return Status.FAILURE
		
	agent._move_to_grid(agent.tile_map.local_to_map(blackboard.board["target"].global_position))
	
	if agent.global_position.distance_squared_to(blackboard.board["target"].global_position) == 0:
		blackboard.board["target"].gatherer = agent
		return Status.SUCCESS
	return Status.RUNNING
