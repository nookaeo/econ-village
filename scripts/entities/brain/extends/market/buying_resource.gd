extends BTSequence
@export var work :Enums.WorkType
@export var item_id :Enums.ItemId
@export var strategy_exception :Enums.Strategy
var safty_factor :float = 1.1

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	var agent_shells_amount :int = 0
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if agent.home.strategy_mode == strategy_exception:
		return 0.0
	if not agent.role.has(Enums.WorkType.BuyResource):
		return 0.0
	var resource_have :float = 0
	var resource_want :float = int((agent.home.house_storage_size * agent.home.rule[item_id]) / ItemData.items[item_id]["weight"])
	if not agent.home.market_data.has(item_id):
		return 0.0
	if agent.home.house_storage.has(item_id):
		resource_have = agent.home.house_storage[item_id]
	if agent.home.market_data[item_id]["Cheapest"] <= 0:
		return 0.0
	blackboard.board["buy_amount"] = min(resource_want - resource_have, agent.weight_handle / ItemData.items[item_id]["weight"])
	#print("AMOUNT:",blackboard.board["buy_amount"])
	if blackboard.board["buy_amount"] < agent.weight_handle / ItemData.items[item_id]["weight"]:
		return 0.0
	if agent.inventory.has(item_id):
		agent_shells_amount = agent.inventory[item_id]
	if float(blackboard.board["buy_amount"] * agent.home.market_data[item_id]["Cheapest"]) * safty_factor > agent.home.house_storage[Enums.ItemId.Shells] + agent_shells_amount:
		return 0.0
	if agent.market_data[item_id]["LeftOver"] < blackboard.board["buy_amount"]:
		return 0.0
	#print("DATA:",blackboard.board["buy_amount"])
	if blackboard.board.has("current_shipping"):
		if blackboard.board["current_shipping"] == work:
			if not blackboard.board.has("buy_resource"):
				return 0.0 
			if blackboard.board["buy_resource"] == item_id:
				return 0.9
			else:
				return 0.0 
	
	var resource_need :float = clamp(pow(clamp((resource_want - resource_have) / resource_want,0,1),(1.0/4.0)),0,1)
	return resource_need
