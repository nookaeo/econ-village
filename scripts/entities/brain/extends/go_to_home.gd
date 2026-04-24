extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	agent._move_to_grid(agent.tile_map.local_to_map(agent.home.global_position))
	if agent.global_position.distance_squared_to(agent.home.global_position) == 0:
		return Status.SUCCESS
	return Status.RUNNING
