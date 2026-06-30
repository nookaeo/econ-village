extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	#var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	blackboard.board.erase("current_shipping")
	#blackboard.board.erase("buy_resource")
	#blackboard.board.erase("sell_resource")
	return Status.SUCCESS
