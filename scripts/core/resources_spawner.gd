extends Node
@export var local_seed :int
@export var tilemap :TileMapLayer
@export var natural_resources_directory :Node
@onready var world_setting :WorldSetting = ($"../..").world_setting
var world_seed :int = CoreConstant.world_seed
var rng = RandomNumberGenerator.new()
var trees_scene = preload("res://scenes/entities/resouces/basic_tree.tscn")
var fish_scene = preload("res://scenes/entities/resouces/basic_fish.tscn")
var cowrie_shell_scene = preload("res://scenes/entities/resouces/cowrie_shell.tscn")
var basic_stone_scene = preload("res://scenes/entities/resouces/basic_stone.tscn")

#////////////////////////////////////////////////////////////////////////
func _ready() -> void:
	rng.seed = world_seed + local_seed
	_resource_spawn(trees_scene, world_setting.tree_spawn_rate,"dirt")
	_resource_spawn(fish_scene, world_setting.fish_spawn_rate,"water")
	_resource_spawn(cowrie_shell_scene, world_setting.cowrie_spawn_rate,"sand")
	_resource_spawn(basic_stone_scene, world_setting.stone_spawn_rate,"stone")
	
func _process(_delta: float) -> void:
	pass
#////////////////////////////////////////////////////////////////////////

func _resource_spawn(scene ,spawn_rate :int,biome :String):
	var placable_tiles :Array  = get_placable_tiles(biome,tilemap)
	for i in range(min(spawn_rate,placable_tiles.size())):
		var resource :NaturalResource = scene.instantiate()
		resource.tile_map = tilemap
		resource.biome = biome
		natural_resources_directory.add_child(resource)
		_place_agent(resource,placable_tiles)
	

func _place_agent(_agent,array :Array) -> void:
	var pos = _seeded_pick(array)
	_agent.position = tilemap.map_to_local(pos)
	array.erase(pos)
	
func _seeded_pick(array: Array):
	if array.is_empty(): 
		return 
	return array[rng.randi() % array.size()]
	
func get_placable_tiles(biome :String,map :TileMapLayer) -> Array:
	var placable :Array = []
	for pos in map.get_used_cells():
		var data :TileData = map.get_cell_tile_data(pos)
		if not data.get_custom_data(biome):
			continue
		placable.append(pos)
	return placable
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
