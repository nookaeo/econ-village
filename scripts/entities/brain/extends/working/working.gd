extends BTUtilitySelector

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	if agent.work_time >= agent.patience_index:
		return 0.0
	if agent.active_energy <= 50:
		return 0.0
	return 0.8
