extends Node
@export var local_seed :int = 24
@export var tilemap :TileMapLayer
@export var agents_directory :Node
@onready var world_setting :WorldSetting = ($"../..").world_setting
@onready var agent_spawn :int = world_setting.villagent_spawn
var world_seed :int = CoreVariable.world_seed
var rng = RandomNumberGenerator.new()
var agent_scene = preload("res://scenes/entities/agents/villagents/villagent_base.tscn")

var x_sex_chromosomes :Array = [
load("res://resources/agent/genetics/sex_chromosomes/x_chromosomes/x_default.tres"),
]

var y_sex_chromosomes :Array = [
load("res://resources/agent/genetics/sex_chromosomes/y_chromosomes/y_default.tres"),
]

func _ready() -> void:
	rng.seed = world_seed + local_seed
	var placable_tiles :Array  = get_placable_tiles(tilemap)
	var random_sex :int
	
	for i in range(agent_spawn):
		var agent :Villagent = agent_scene.instantiate()
		random_sex = rng.randi_range(0,1)
		agent.genetics.sex.first = _seeded_pick(x_sex_chromosomes)
		if random_sex == 0:
			agent.genetics.sex.second = _seeded_pick(y_sex_chromosomes)
		elif random_sex == 1:
			agent.genetics.sex.second = _seeded_pick(x_sex_chromosomes)
		agent.age += 576
		agent.tile_map = tilemap
		agents_directory.add_child(agent)
		_place_agent(agent,placable_tiles)
	

func _process(_delta: float) -> void:
	pass
	

func _place_agent(_agent,array :Array) -> void:
	var pos = _seeded_pick(array)
	_agent.position = tilemap.map_to_local(pos)
	array.erase(pos)
	
func _seeded_pick(array: Array):
	if array.is_empty(): 
		return 
	return array[rng.randi() % array.size()]
	
func get_placable_tiles(map :TileMapLayer) -> Array:
	var placable :Array = []
	for pos in map.get_used_cells():
		var data :TileData = map.get_cell_tile_data(pos)
		if not data.get_custom_data("grass"):
			continue
		placable.append(pos)
	return placable
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
