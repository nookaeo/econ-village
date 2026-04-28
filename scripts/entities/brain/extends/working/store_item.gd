extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	if agent.home.house_weight < agent.home.house_storage_size :
		agent.store_item_to_home()
		return Status.SUCCESS
	return Status.FAILURE
