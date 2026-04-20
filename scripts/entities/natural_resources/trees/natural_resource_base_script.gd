extends Node2D
class_name NaturalResource
@export var natural_resource_data :NaturalResources
var tile_map :TileMapLayer
var biome :String
var gatherer :Node
var gather_time :float



#/////////////////////////////////////////////////////////
func _ready() -> void:
	var current_tile := tile_map.local_to_map(global_position)
	tile_map.get_cell_tile_data(current_tile).get_custom_data("placable") 
	
	pass
#/////////////////////////////////////////////////////////

func get_placable_tiles(_biome :String,map :TileMapLayer) -> Array:
	var placable :Array = []
	for pos in map.get_used_cells():
		var data :TileData = map.get_cell_tile_data(pos)
		if not data.get_custom_data(_biome):
			continue
		placable.append(pos)
	return placable
	
