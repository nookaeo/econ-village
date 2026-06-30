extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	var resource_have :float = 0
	var resource_want :float = int((agent.home.house_storage_size * agent.home.rule[Enums.ItemId.Wood]) / ItemData.items[Enums.ItemId.Wood]["weight"])

	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if not agent.role.has(Enums.WorkType.CutTree):
		return 0.0
	if get_tree().get_nodes_in_group("Tree").size() == 0:
		return 0.0
	if agent.home.house_storage.has(Enums.ItemId.Wood):
		resource_have = agent.home.house_storage[Enums.ItemId.Wood]
		
	var resource_need :float = clamp(pow(clamp((resource_want - resource_have) / resource_want,0,1),1) * 0.8,0.1,1)
	if blackboard.board.has("current_work"):
		if blackboard.board["current_work"] == Enums.WorkType.CutTree:
			return 0.8
	if agent.home.strategy_mode == Enums.Strategy.Lumberjack:
		return 0.8
	

	if not agent.gather_statistic.has(Enums.ItemId.Wood):
		return clamp(resource_need * 1.2 ,0,0.8)
	#print("resource: ",resource_need)
	return resource_need
