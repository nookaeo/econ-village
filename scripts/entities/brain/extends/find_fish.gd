extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	#var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	if is_instance_valid(NatResourceManager.find_nearest_resource(_actor,"Fish")):
		blackboard.board["target"] = NatResourceManager.find_nearest_resource(_actor,"Fish")
		return Status.SUCCESS
	return Status.FAILURE
