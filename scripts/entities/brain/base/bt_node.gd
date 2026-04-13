extends Node
class_name BTNode

enum Status { RUNNING, SUCCESS, FAILURE }

func get_utility_score(_actor :Node) -> float:
	return 0.0

func tick(_actor: Node, _blackboard :Node) -> Status:
	return Status.SUCCESS
