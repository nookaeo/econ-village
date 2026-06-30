extends BTUtilitySelector

func get_utility_score(_actor :Node) -> float:
	var blackboard :Blackboard = %Blackboard
	var agent :Villagent = _actor
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if agent.work_time >= agent.patience_index:
		return 0.0
	if agent.active_energy <= 50:
		return 0.0
	if agent.home.strategy_mode == Enums.Strategy.None:
		return 0.0
	if not agent.role.has(Enums.WorkType.CatchFish) and not agent.role.has(Enums.WorkType.FindShell) and not agent.role.has(Enums.WorkType.CutTree) and not agent.role.has(Enums.WorkType.MineStone):
		return 0.0
	if blackboard.board.has("current_work"):
		if blackboard.board["current_work"] == Enums.WorkType.SellResource or blackboard.board["current_work"] == Enums.WorkType.BuyResource:
			return 0.0

	return 0.8
