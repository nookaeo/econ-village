extends BTSequence
func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var rest_need :float = clamp(pow((agent.max_active_energy - agent.active_energy) / agent.max_active_energy,4),0,1)
	#print("rest:",rest_need)
	return rest_need
