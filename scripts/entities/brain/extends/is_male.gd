extends BTCondition
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	if agent.sex == "male":
		return Status.FAILURE
	return Status.SUCCESS
