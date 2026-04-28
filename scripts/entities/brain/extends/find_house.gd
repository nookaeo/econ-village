extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var all_male :Array = get_tree().get_nodes_in_group("male")
	#var blackboard :Blackboard = _blackboard
	for male :Villagent in all_male:
		if male.partner == null and male.home != null:
			if male.home.house_level  == 0:
				continue
			male.partner = agent
			agent.partner = male
			agent.home = agent.partner.home
			agent.home.house_member.append(agent)
			return Status.SUCCESS
	#return Status.FAILURE
	return Status.RUNNING
