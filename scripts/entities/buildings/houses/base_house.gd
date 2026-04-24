extends Node2D
class_name House

@export var house_level_1 :BaseHouseData
@export var house_level_2 :BaseHouseData
@export var house_level_3 :BaseHouseData

var house_level :int = 0
var house_owner :Villagent
var house_member :Array
var house_storage_size :float = 0.0
var house_storage :Dictionary
var house_tool_storage :Dictionary
var build_time :float = 0
var house_weight :float = 0.0
var role_rules :Dictionary
var storage_rule :Dictionary

func _ready() -> void:
	CoreSignal.day_pass.connect(func info() -> void:
		print(house_storage)
		)


func _process(_delta: float) -> void:
	pass

func build_house() -> void:
	var delta = get_physics_process_delta_time()
	build_time += delta * (house_owner.strength / 100.0)
	house_owner.active_energy -= delta * (house_owner.strength / 100.0)
	if build_time < house_level_1.building_time:
		return
	%Sprite2D.texture = house_level_1.texture
	house_level = 1
	house_storage_size = house_level_1.storage_size


func calculate_weight() -> void:
	house_weight = 0
	if house_storage.size() <= 0 :
		return
	for item in house_storage:
		house_weight += house_storage[item] * ItemData.items[item]["weight"]
	#print(house_storage," : ",house_weight)
	
