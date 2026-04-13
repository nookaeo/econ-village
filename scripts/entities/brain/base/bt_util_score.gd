class_name BTUtilityScore
extends BTNode
	
func tick(actor: Node, blackboard :Node) -> Status:
	if get_children().size() > 0:
		return get_children()[0].tick(actor,blackboard)
	return Status.FAILURE
	
