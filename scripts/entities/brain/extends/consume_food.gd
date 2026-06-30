extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	var fish :Enums.ItemId = Enums.ItemId.Fish
	if not agent.home.house_storage.has(fish):
		#print("NO FOOD")
		return Status.SUCCESS
	var need_energy :float = agent.max_passive_energy - agent.passive_energy
	var fish_consume_amount :int = min(agent.home.house_storage[fish],int(need_energy / ItemData.items[fish]["energy"]))
	agent.passive_energy += fish_consume_amount * ItemData.items[fish]["energy"]
	agent.home.remove_item(fish,fish_consume_amount)
	agent.home.household_resource_consumed[fish] += fish_consume_amount
	return Status.SUCCESS
