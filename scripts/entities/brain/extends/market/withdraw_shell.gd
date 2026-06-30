extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	var market :Market = blackboard.board["market"]
	
	market.withdraw_shells(agent)
	
	return Status.SUCCESS
