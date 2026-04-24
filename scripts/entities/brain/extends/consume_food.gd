extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	var fish :ItemData.ItemName = ItemData.ItemName.Fish
	if not agent.home.house_storage.has(fish):
		#print("NO FOOD")
		return Status.FAILURE
	var need_energy :float = agent.max_passive_energy - agent.passive_energy
	var fish_consume_amount :int = min(agent.home.house_storage[fish],int(need_energy / ItemData.items[fish]["energy"]))
	agent.passive_energy += fish_consume_amount * ItemData.items[fish]["energy"]
	agent.home.house_storage[fish] -= fish_consume_amount
	return Status.SUCCESS
