extends BTAction
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	if not is_instance_valid(blackboard.board["target"]):
		#print("Fish: ",agent.inventory[3])
		return Status.SUCCESS
		
	if blackboard.board["target"].gatherer != agent :
		return Status.FAILURE
	if agent.active_energy <= 10:
		return Status.FAILURE
	blackboard.board["target"].gather()

	return Status.RUNNING
