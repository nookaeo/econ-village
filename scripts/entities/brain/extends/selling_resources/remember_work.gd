extends BTAction
@export var work :Enums.WorkType
func tick(_actor: Node, _blackboard :Node) -> Status:
	#var agent :Villagent = _actor
	var blackboard :Blackboard = _blackboard
	blackboard.board["current_shipping"] = work
	return Status.SUCCESS
