extends BTAction
@export var nat_resource :String
@export var work_type :Enums.WorkType
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	
	if is_instance_valid(NatResourceManager.find_nearest_resource(_actor,nat_resource)):
		blackboard.board["current_work"] = work_type
		blackboard.board["target"] = NatResourceManager.find_nearest_resource(_actor,nat_resource)
		return Status.SUCCESS
		
	agent._move_to_grid(agent.tile_map.local_to_map(agent.home.global_position))
	return Status.FAILURE
