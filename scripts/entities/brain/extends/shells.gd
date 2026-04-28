extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if not agent.home.role[agent.sex].has("Shell"):
		return 0.0
	if get_tree().get_nodes_in_group("Shell").size() <= 1:
		return 0.0
	
	#print("resource: ",resource_need)
	if blackboard.board.has("work"):
		if blackboard.board["work"] != "Shell":
			return 0.0
	if not agent.gather_statistic.has(ItemData.ItemName.Shells):
		return 0.8
	return 0.3
