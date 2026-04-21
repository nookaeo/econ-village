extends Node

@export var tilemap :TileMapLayer

func _ready() -> void:
	TilesManager.tiles["grass"] = get_biome_tiles("grass",tilemap)
	TilesManager.tiles["sand"] = get_biome_tiles("sand",tilemap)
	TilesManager.tiles["stone"] = get_biome_tiles("stone",tilemap)
	TilesManager.tiles["water"] = get_biome_tiles("water",tilemap)
	TilesManager.tiles["dirt"] = get_biome_tiles("dirt",tilemap)
	
func get_biome_tiles(biome :String,map :TileMapLayer) -> Dictionary:
	var _tiles :Dictionary = {}
	for pos in map.get_used_cells():
		var data :TileData = map.get_cell_tile_data(pos)
		if not data.get_custom_data(biome):
			continue
		_tiles[pos] = true
	return _tiles
