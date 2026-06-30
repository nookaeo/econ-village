extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	var fish_have :float = 0
	var fish_want :float = int((agent.home.house_storage_size * agent.home.rule[Enums.ItemId.Fish]) / ItemData.items[Enums.ItemId.Fish]["weight"])

	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if get_tree().get_nodes_in_group("Fish").size() == 0:
		return 0.0
	if not agent.role.has(Enums.WorkType.CatchFish):
		return 0.0
	if agent.home.house_storage.has(3):
		fish_have = agent.home.house_storage[3]
	if agent.home.strategy_mode == Enums.Strategy.FishCatcher:
		return 0.8
	if blackboard.board.has("current_work"):
		if blackboard.board["current_work"] == Enums.WorkType.CatchFish:
			return 0.8
	
	var fish_need :float = clamp(pow(clamp((fish_want - fish_have) / fish_want,0,1),(1.0/2.0)) * 0.8, 0.1,1)
	if not agent.gather_statistic.has(Enums.ItemId.Fish):
		return clamp(fish_need * 1.2 , 0, 0.8)
	
	#print("fish: ",fish_need)
	return fish_need
