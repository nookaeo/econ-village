extends Node2D
class_name House

@export var house_level_1 :BaseHouseData
@export var house_level_2 :BaseHouseData
@export var house_level_3 :BaseHouseData
@export var healthy_household :float = 1.0
@export var unhealthy_household :float = 0.8

var house_level :int = 0
var house_owner :Villagent
var house_member :Array
var house_storage_size :float = 0.0
var house_storage :Dictionary = {3:0,1:0,0:0}
var house_tool_storage :Dictionary
var build_time :float = 0
var house_weight :float = 0.0
var rule :Dictionary
var role :Dictionary
var household_health :float = unhealthy_household
func _ready() -> void:
	CoreSignal.day_pass.connect(func info() -> void:
		_maintain_household()
		#if house_member.size() >= 1 and house_owner :
		#	print(house_storage,"    Male:",house_owner.gather_statistic,"    Female:",house_member[0].gather_statistic)
		#elif house_owner:
		#	print(house_storage,"Male:",house_owner.gather_statistic)
		#elif house_member.size() >= 1:
		#	print(house_storage,"Female:",house_member[0].gather_statistic)
		#else :
		#	print(house_storage)
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

func _maintain_household() -> void:
	var house_maintain_resources :Dictionary = house_level_1.house_maintainance.duplicate(true)
	for resource_id :int in house_maintain_resources:
		if not house_storage.has(resource_id):
			household_health = unhealthy_household
			return
		if house_storage[resource_id] < house_maintain_resources[resource_id]:
			household_health = unhealthy_household
			return 
		
		house_storage[resource_id] -= house_maintain_resources[resource_id]
		household_health = healthy_household
		
		
	
	
	
	
