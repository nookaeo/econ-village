extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	#var delta = get_physics_process_delta_time()

	if agent.home == null:
		CoreSignal.create_house.emit(agent)
		return Status.SUCCESS
	
	return Status.FAILURE
