extends BTAction
var sleep_time :float = 8.0
var sleep :float = 0
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	var delta = get_physics_process_delta_time()
	sleep += delta
	if sleep < sleep_time:
		return Status.RUNNING
	var need_energy = min(agent.max_active_energy - agent.active_energy, agent.passive_energy)
	agent.active_energy += need_energy * agent.home.household_health
	agent.passive_energy -= need_energy 
	agent.work_time = 0
	agent.is_tired = false
	sleep = 0
	blackboard.board.erase("work")
	#print("ACTIVE: ",agent.active_energy)

	return Status.SUCCESS
