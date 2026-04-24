extends BTSelector
func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	if agent.age < agent.kid_phase:
			return 0.0
	if agent.home != null:
		if agent.home.house_level > 0:
			return 0.0
	return 1.0
