extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var time_factor :float = 0
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1 :
		return 0.0
	if agent.day_time >= 20.0 or agent.is_tired:
		agent.is_tired = true
		return 2.0
	var rest_need :float = clamp(pow((agent.max_active_energy - agent.active_energy) / agent.max_active_energy,4) + time_factor,0,1)
	#print("rest:",rest_need)
	return rest_need
