extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var fish_have :float = 0
	var fish_want :float = 500
	if agent.inventory.has(3):
		fish_have = agent.inventory[3]
	if agent.active_energy <= 10:
		return 0.0
	var fish_need :float = clamp((fish_want - fish_have) / fish_want,0,1)
	#print("fish: ",fish_need)
	return fish_need
