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
var market_data :Dictionary
var household_resource_consumed_statistic :Dictionary = {}
var household_resource_consumed :Dictionary = {1:0,2:0,3:0}
var avg_household_resource_consumed_day :Dictionary = {}
var strategy_mode :Enums.Strategy = Enums.Strategy.None

var provider :Villagent
var supporter :Villagent
var household_health :float = unhealthy_household
var ordering_info :Dictionary = {
	"base_margin":0.0,
	"margin":0.0,
	"sensitivity":0.0
	
}
func _ready() -> void:
	CoreSignal.day_pass.connect(func () -> void:
		_maintain_household()
		calculate_statistic()
		%Resources.text = var_to_str(house_storage)
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

func store_item(agent :Villagent) -> void:
	if house_level < 1:
		return
	if agent.inventory.size() < 1:
		return
	for item in agent.inventory:
		if not house_storage.has(item):
			house_storage[item] = 0
		house_storage[item] += agent.inventory[item]
		
	agent.inventory.clear()
	agent.calculate_weight()
	calculate_weight()
	
func remove_item(item_name :Enums.ItemId,amount :int):
	if not house_storage.has(item_name):
		return
	if house_storage[item_name] < amount:
		return
	house_storage[item_name] -= amount
	calculate_weight()
	
	
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
		household_resource_consumed[resource_id] += house_maintain_resources[resource_id]
		remove_item(resource_id,house_maintain_resources[resource_id])
		household_health = healthy_household
		

func make_house(_agent :Villagent) -> void:
	pass
	
func count_household_resource_consume(item_id :Enums.ItemId, amount :int):
	if not household_resource_consumed.has(item_id):
		household_resource_consumed[item_id] = 0
	household_resource_consumed[item_id] += amount
	
func calculate_statistic():
	for item_id in household_resource_consumed:
		if not household_resource_consumed_statistic.has(item_id):
			household_resource_consumed_statistic[item_id] = []
		household_resource_consumed_statistic[item_id].push_front(household_resource_consumed[item_id])
		if household_resource_consumed_statistic[item_id].size() > 7:
			household_resource_consumed_statistic[item_id].resize(7)
	household_resource_consumed = {0:0,1:0,2:0,3:0}
	for item_id in household_resource_consumed_statistic:
		avg_household_resource_consumed_day[item_id] = Math.find_mean(household_resource_consumed_statistic[item_id])
	#print("AVG_CONSUMED",avg_household_resource_consumed_day)
	
func assign_role(agent :Villagent) -> void:
	var strategy :Dictionary = {
		Enums.Strategy.None:"None",
		Enums.Strategy.SelfSufficient:"SelfSufficient",
		Enums.Strategy.ShellFinder:"ShellFinder",
		Enums.Strategy.FishCatcher:"FishCatcher",
		Enums.Strategy.Lumberjack:"LumberJack",
		Enums.Strategy.StoneMiner:"StoneMiner",
	
	}
	if agent != house_owner:
		return
	agent.role.clear()
	agent.role.assign(agent.role_responsibilities[strategy_mode]["provider"])
	%Strategy.text = strategy[strategy_mode]
	if agent.partner == null:
		return
	agent.partner.role.clear()
	agent.partner.role.assign(agent.role_responsibilities[strategy_mode]["supporter"])
	
	#print(agent.role," : ",agent.partner.role)
	
