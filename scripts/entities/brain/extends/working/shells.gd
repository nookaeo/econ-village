extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var blackboard :Blackboard = %Blackboard
	
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if not agent.role.has(Enums.WorkType.FindShell):
		return 0.0
	if get_tree().get_nodes_in_group("Shell").size() <= 1:
		return 0.0
	
	if agent.home.strategy_mode == Enums.Strategy.ShellFinder:
		return 0.8
	#print("resource: ",resource_need)
	if blackboard.board.has("current_work"):
		if blackboard.board["current_work"] != Enums.WorkType.FindShell:
			return 0.8
	
	if not agent.gather_statistic.has(Enums.ItemId.Shells):
		return 0.7
	return 0.0
