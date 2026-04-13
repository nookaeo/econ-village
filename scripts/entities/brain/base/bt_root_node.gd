@icon("res://assets/arts/icons/root.svg")
class_name BTRoot
extends Node

@export var actor :Node
@export var blackboard :Node

func _ready() -> void:
	pass 

func _physics_process(_delta: float) -> void:
	tick(actor, blackboard)


func tick(_actor :Node, _blackboard :Node):
	self.get_children()[0].tick(_actor, _blackboard)
