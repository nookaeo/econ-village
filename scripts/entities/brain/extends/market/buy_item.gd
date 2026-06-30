extends BTAction
@export var item_id :Enums.ItemId
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	var market :Market = blackboard.board["market"]
	var buy_amount = blackboard.board["buy_amount"]
	if agent.global_position.distance_squared_to(market.global_position) == 0:
		market.buy(agent,item_id,buy_amount)
		return Status.SUCCESS
	
	return Status.FAILURE
	
