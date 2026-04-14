extends Node

@export var world_setting :WorldSetting
@onready var time_simulation_day :int = world_setting.time_simulation_day
@onready var time_scale = world_setting.time_scale
var day_passed :int = 0
var time_count :float = 0
var death_list :Dictionary
##############################################################
func _ready() -> void:
	Engine.time_scale = time_scale
	CoreSignal.birth.connect(sign_birth)

func _process(delta: float) -> void:
	count_day(delta)
	

##############################################################


func count_day(delta :float) -> void :
	time_count += delta
	if time_count >= time_simulation_day:
		day_passed += 1
		time_count -= time_simulation_day
		print("day: ",day_passed)
		#print(death_list)
		death_handler()
		
	
func sign_birth(agent :Node, life_span :int) -> void:
	if death_list.has(day_passed + life_span):
		death_list[day_passed + life_span].append(agent)
	else :
		death_list[day_passed + life_span] = [agent]

func death_handler() -> void:
	if not death_list.has(day_passed):
		return
	for agent in  death_list[day_passed]:
		if is_instance_valid(agent):
			agent.die()
	death_list.erase(day_passed)
	
	
	
