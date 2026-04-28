extends Node2D
class_name NaturalResource
@export var natural_resource_data :NaturalResources
@export var max_own_time :int = 2
var tile_map :TileMapLayer
var biome :String
var gatherer :Villagent = null
var gather_progress :float
var own_time :int = 0
@onready var drop_amount :int =  natural_resource_data.drop_amount


#/////////////////////////////////////////////////////////
func _ready() -> void:
	CoreSignal.current_second.connect(func clear_gatherer(_second) -> void:
		own_time += 1
		if own_time >= max_own_time:
			gather_progress = 0
			gatherer = null
		)
		
func _process(_delta: float) -> void:
	pass
#/////////////////////////////////////////////////////////

func gather() -> bool:
	var delta = get_physics_process_delta_time()
	var strength_rate :float = gatherer.strength / 100.0
	gather_progress +=  strength_rate * delta
	#gatherer.active_energy -=  strength_rate * natural_resource_data.gather_hardness * delta
	own_time = 0
	if gather_progress < natural_resource_data.gather_time:
		return false
	if drop_amount == 0 :
		return false

	NatResourceManager.unregister_resource(self)
	TilesManager.tiles[biome][tile_map.local_to_map(global_position)] = true
	gatherer.add_item(natural_resource_data.item_name,natural_resource_data.drop_amount)
	gatherer.count_gather_resource(natural_resource_data.item_name,natural_resource_data.drop_amount)
	gatherer.active_energy -= strength_rate * natural_resource_data.gather_time * natural_resource_data.gather_hardness
	gatherer.work_time += natural_resource_data.gather_time * (2.0 - strength_rate)
	drop_amount = 0
	self.queue_free()
	return true
