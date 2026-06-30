extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = %Blackboard
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if agent != agent.home.house_owner:
		return 0.0
	if agent.home.strategy_mode != Enums.Strategy.None:
		return 0.0
	return 0.90
