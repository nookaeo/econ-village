extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	if agent.home.house_weight < agent.home.house_storage_size :
		agent.home.store_item(agent)
		return Status.SUCCESS
	return Status.FAILURE
