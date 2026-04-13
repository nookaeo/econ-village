@icon("res://assets/arts/icons/selector.svg")
extends BTNode
class_name BTSelector


var current_child_index :int = 0

func tick(actor: Node, blackboard :Node) -> Status:
	var children = get_children()
	
	while current_child_index < children.size():
		var child = children[current_child_index]
		if not child is BTNode:
			current_child_index += 1
			continue
			
		var result = child.tick(actor, blackboard)
		
		if result == Status.RUNNING:
			return Status.RUNNING
		if result == Status.SUCCESS:
			current_child_index = 0
			return Status.SUCCESS
		
		current_child_index += 1
			
	current_child_index = 0
	return Status.FAILURE
