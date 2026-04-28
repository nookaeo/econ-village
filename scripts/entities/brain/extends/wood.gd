extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	var resource_have :float = 0
	var resource_want :float = int((agent.home.house_storage_size * agent.home.rule["WoodStock"]) / ItemData.items[ItemData.ItemName.Wood]["weight"])

	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if not agent.home.role[agent.sex].has("Wood"):
		return 0.0
	if get_tree().get_nodes_in_group("Tree").size() <= 1:
		return 0.0
	if agent.home.house_storage.has(ItemData.ItemName.Wood):
		resource_have = agent.home.house_storage[ItemData.ItemName.Wood]
	

	var resource_need :float = clamp(pow((resource_want - resource_have) / resource_want,(1.0/8.0)),0,1)
	if blackboard.board.has("work"):
		if blackboard.board["work"] != "Tree":
			return 0.0
	if not agent.gather_statistic.has(ItemData.ItemName.Wood):
		return 0.8
	#print("resource: ",resource_need)
	return resource_need
