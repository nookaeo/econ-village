extends BTSequence
func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	var is_shipping :bool
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if agent.market_id <= 0:
		return 0.0
		
	if not agent.role.has(Enums.WorkType.SellResource):
		return 0.0
	if blackboard.board.has("current_shipping"):
		if blackboard.board["current_shipping"] != Enums.WorkType.SellResource:
			is_shipping = false
			return 0.0
		is_shipping = true
	
	for resource_id in agent.home.rule:
		if is_shipping or (agent.home.house_storage[resource_id] * ItemData.items[resource_id]["weight"]) - (agent.home.house_storage_size * agent.home.rule[resource_id]) >= agent.weight_handle:
			return 0.7
	return 0.5
