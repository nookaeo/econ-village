extends BTSequence

func get_utility_score(_actor :Node) -> float:
	var agent :Villagent = _actor
	var fish_have :float = 0
	var fish_want :float = 400
	if agent.home == null:
		return 0.0
	if agent.home.house_level < 1:
		return 0.0
	if agent.home.house_storage.has(3):
		fish_have = agent.home.house_storage[3]
	if agent.active_energy <= 10:
		return 0.0
	var fish_need :float = clamp((fish_want - fish_have) / fish_want,0,1)
	#print("fish: ",fish_need)
	return fish_need
