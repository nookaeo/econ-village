extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	if not agent.inventory.has(3):
		return Status.FAILURE
	if agent.inventory[3] <= 0:
		return Status.FAILURE
	var need_energy :float = agent.max_passive_energy - agent.passive_energy
	var fish_consume_amount :int = min(agent.inventory[3],int(need_energy / ItemData.items[3]["energy"]))
	agent.passive_energy += fish_consume_amount * ItemData.items[3]["energy"]
	agent.inventory[3] -= fish_consume_amount
	return Status.SUCCESS
