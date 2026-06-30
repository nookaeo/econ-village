extends BTAction
@export var item_id :Enums.ItemId
var safty_factor :float = 1.1

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	var resource_have :float = 0
	var resource_want :float = int((agent.home.house_storage_size * agent.home.rule[item_id]) / ItemData.items[item_id]["weight"])
	if agent.home.house_storage.has(item_id):
		resource_have = agent.home.house_storage[item_id]
	blackboard.board["buy_amount"] = min(resource_want - resource_have, agent.weight_handle / ItemData.items[item_id]["weight"])
	var buy_amount :float = blackboard.board["buy_amount"]
	if not agent.home.market_data.has(item_id):
		return Status.FAILURE
	var price :float = int(float(agent.home.market_data[item_id]["Cheapest"]) * safty_factor)
	if agent.global_position.distance_squared_to(agent.home.global_position) != 0:
		return Status.FAILURE
	
	agent.add_item(Enums.ItemId.Shells,int(buy_amount * price))
	agent.home.remove_item(Enums.ItemId.Shells,int(buy_amount * price))
	return Status.SUCCESS
