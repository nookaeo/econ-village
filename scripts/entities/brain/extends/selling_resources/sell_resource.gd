extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	var last_price :float = 0.0
	var market_sell_amount :float = 0.0
	var shipping_resource :Enums.ItemId = blackboard.board["sell_resource"]
	if agent.market_data.has(shipping_resource):
		last_price = agent.market_data[shipping_resource]["LastPrice"]
	if agent.market_data.has(shipping_resource):
		market_sell_amount = agent.market_data[shipping_resource]["SellAmount"]

	if not get_tree().get_first_node_in_group("Market"):
		return Status.FAILURE
	if not blackboard.board.has("market"):
		return Status.FAILURE
	var market :Market = blackboard.board["market"]
	if agent.global_position.distance_squared_to(market.global_position) != 0:
		return Status.FAILURE
	if not agent.inventory.has(shipping_resource):
		return Status.SUCCESS
	if agent.inventory[shipping_resource] <= 0:
		return Status.SUCCESS
		
	if last_price == 0:
		var price :float = 0
		if agent.home.ordering_info["resources_ratio"].has(Enums.ItemId.Shells) and agent.home.ordering_info["resources_ratio"].has(shipping_resource):
			price = (agent.home.ordering_info["resources_ratio"][Enums.ItemId.Shells] / agent.home.ordering_info["resources_ratio"][shipping_resource]) * 1.5
		else: 
			price = 1
		market.create_sell_order(agent, shipping_resource,agent.inventory[shipping_resource],int(price))
		
		
	elif last_price >= 2 and market_sell_amount > 0:
		var sensitivity :float = agent.home.ordering_info["sensitivity"]
		var base_margin :float = agent.home.ordering_info["base_margin"]
		var margin :float = agent.home.ordering_info["margin"]
		var sell_price :int = max(1,int(last_price * (1.0 / ( 1.0 + sensitivity * (margin - base_margin)))))
		market.create_sell_order(agent, shipping_resource,agent.inventory[shipping_resource], sell_price)
	elif last_price >= 1 and market_sell_amount == 0:
		market.create_sell_order(agent, shipping_resource,agent.inventory[shipping_resource],int(ceilf(last_price * (1 + 0.1))))
	return Status.SUCCESS
