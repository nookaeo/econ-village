extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	var fish_have :float = 0
	var fish_want :float = int((agent.home.house_storage_size * agent.home.rule["FoodStock"]) / ItemData.items[ItemData.ItemName.Fish]["weight"])

	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if get_tree().get_nodes_in_group("Fish").size() <= 1:
		return 0.0
	if not agent.home.role[agent.sex].has("Food"):
		return 0.0
	if agent.home.house_storage.has(3):
		fish_have = agent.home.house_storage[3]
	if blackboard.board.has("work"):
		if blackboard.board["work"] != "Fish":
			return 0.0
	if not agent.gather_statistic.has(ItemData.ItemName.Fish):
		return 0.8
	var fish_need :float = clamp(pow((fish_want - fish_have) / fish_want,0.5),0,1)
	#print("fish: ",fish_need)
	return fish_need
