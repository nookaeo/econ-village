extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	#var delta = get_physics_process_delta_time()
	CoreSignal.create_house.emit(agent)
	if agent.home == null:
		return Status.FAILURE
	return Status.SUCCESS
