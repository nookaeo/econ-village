extends Node
@export var local_seed :int
@export var tilemap :TileMapLayer
@export var natural_resources_directory :Node
@onready var world_setting :WorldSetting = ($"../..").world_setting
@onready var crowd_rate :float = world_setting.resources_crowd_rate
var world_seed :int = CoreConstant.world_seed
var rng = RandomNumberGenerator.new()

var trees_scene = preload("res://scenes/entities/natural_resources/basic_tree.tscn")
var fish_scene = preload("res://scenes/entities/natural_resources/basic_fish.tscn")
var cowrie_shell_scene = preload("res://scenes/entities/natural_resources/cowrie_shell.tscn")
var basic_stone_scene = preload("res://scenes/entities/natural_resources/basic_stone.tscn")
var day_pass :int = 0
#////////////////////////////////////////////////////////////////////////
func _ready() -> void:
	rng.seed = world_seed + local_seed
	_resources_spawn()
	CoreSignal.day_pass.connect(_resources_spawn)
#////////////////////////////////////////////////////////////////////////
func _resources_spawn() -> void:
	day_pass += 1
	_resource_spawn(trees_scene, world_setting.tree_spawn_rate,"dirt")
	_resource_spawn(fish_scene, world_setting.fish_spawn_rate,"water")
	_resource_spawn(cowrie_shell_scene, world_setting.cowrie_spawn_rate,"sand")
	_resource_spawn(basic_stone_scene, world_setting.stone_spawn_rate,"stone")
	
func _resource_spawn(scene ,spawn_rate :int,biome :String):
	var placable_tiles :Array  = get_placable_tiles(biome)
	if placable_tiles.size() <= 0 or placable_tiles.size() < int(TilesManager.tiles[biome].size() * (1.0 - crowd_rate)) :
		return
	for i in range(min(spawn_rate,placable_tiles.size())):
		var resource :NaturalResource = scene.instantiate()
		resource.tile_map = tilemap
		resource.biome = biome
		natural_resources_directory.add_child(resource)
		NatResourceManager.register_resource(resource)
		_place_entity(resource,placable_tiles,biome)
		
	
 
func _place_entity(_entity,array :Array,biome :String) -> void:
	var pos = _seeded_pick(array)
	_entity.position = tilemap.map_to_local(pos)
	array.erase(pos)
	TilesManager.tiles[biome][pos] = false

func _seeded_pick(array: Array):
	if array.is_empty(): 
		return 
	var _index :int = rng.randi() % array.size()
	return array[_index]
	
func get_placable_tiles(biome :String) -> Array:
	var placable :Array = []
	for tile in TilesManager.tiles[biome]:
		if not TilesManager.tiles[biome][tile]:
			continue
		placable.append(tile)
	return placable
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
