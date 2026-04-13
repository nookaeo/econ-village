@icon("res://assets/arts/icons/utility_selector.svg")
class_name BTUtilitySelector
extends BTNode

var active_child :BTNode = null

func get_utility_score(actor :Node) -> float:
	var max_score = 0.0
	for child in get_children():
		if child is BTNode:
			max_score = max(max_score, child.get_utility_score(actor))
	return max_score

func tick(actor :Node, blackboard :Node) -> Status:
	var best_child :BTNode = null
	var max_score = -1.0
	for child in get_children():
		if child is BTNode:
			var score = child.get_utility_score(actor)
			if child == active_child:
				score += 0.1 
			
			if score > max_score:
				max_score = score
				best_child = child

	if best_child != active_child:
		active_child = best_child
	
	if active_child:
		return active_child.tick(actor, blackboard)
	return Status.FAILURE
