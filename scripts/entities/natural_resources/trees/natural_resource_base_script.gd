extends Node2D
class_name NaturalResource
@export var natural_resource_data :NaturalResources
var tile_map :TileMapLayer
var biome :String
var gatherer :Node
var gather_time :float



#/////////////////////////////////////////////////////////
func _ready() -> void:
	
	pass
#/////////////////////////////////////////////////////////

func gather() -> bool:
	pass
	return false
