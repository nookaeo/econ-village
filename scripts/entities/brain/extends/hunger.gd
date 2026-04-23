extends BTSequence
func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	if not agent.inventory.has(3):
		return 0.0
	if agent.inventory[3] <= 0:
		return 0.0
	var food_need :float = clamp(pow((agent.max_passive_energy - agent.passive_energy) / agent.max_passive_energy,0.25),0,1)
	#print("food:",food_need)
	return food_need
