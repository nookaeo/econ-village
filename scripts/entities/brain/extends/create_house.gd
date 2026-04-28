extends BTAction

func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	#var delta = get_physics_process_delta_time()
	if agent.home.house_level >= 1:
		return Status.SUCCESS
	agent.home.build_house()
	agent.home.rule.assign(agent.rule)
	agent.home.role.assign(agent.role)
	return Status.RUNNING
