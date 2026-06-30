extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	#var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	blackboard.board.erase("buy_resource")
	blackboard.board["buy_amount"] = 0
	return Status.SUCCESS
