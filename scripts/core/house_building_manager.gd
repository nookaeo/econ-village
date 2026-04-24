extends Node

@export var tile_map :TileMapLayer
@export var building_directory :Node
var house_scene = preload("res://scenes/entities/buildings/base_house.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CoreSignal.create_house.connect(create_house_site)

func create_house_site(agent :Villagent) -> void:
	var house :House = house_scene.instantiate()
	var tile_pos = tile_map.local_to_map(agent.position)
	house.position = tile_map.map_to_local(tile_pos)
	building_directory.add_child(house)
	agent.home = house
	agent.home.house_owner = agent
