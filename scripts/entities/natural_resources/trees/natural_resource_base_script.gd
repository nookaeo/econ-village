extends Node2D
class_name NaturalResource
@export var natural_resource_data :NaturalResources
var tile_map :TileMapLayer
var biome :String
var gatherer :Villagent = null
var gather_progress :float
@onready var drop_amount :int =  natural_resource_data.drop_amount


#/////////////////////////////////////////////////////////
func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
#/////////////////////////////////////////////////////////

func gather() -> bool:
	var delta = get_physics_process_delta_time()
	gather_progress += 1.0 * delta
	gatherer.active_energy -= natural_resource_data.gather_hardness * delta
	if gather_progress < natural_resource_data.gather_time:
		return false
	if drop_amount == 0 :
		return false
	NatResourceManager.unregister_resource(self)
	TilesManager.tiles[biome][tile_map.local_to_map(global_position)] = true
	if not gatherer.inventory.has(natural_resource_data.item_id):
		gatherer.inventory[natural_resource_data.item_id] = 0
	gatherer.inventory[natural_resource_data.item_id] += drop_amount
	drop_amount = 0
	self.queue_free()
	return true
