extends Node

@onready var world_setting :WorldSetting = ($"../..").world_setting
@onready var time_simulation_day :int = CoreConstant.time_simulation_day
@onready var time_scale = world_setting.time_scale
var day_passed :int = 0
var time_count :float = 0
var death_list :Dictionary
var second :float = 0
var second_count :float = 0
##############################################################
func _ready() -> void:
	Engine.time_scale = time_scale
	CoreSignal.birth.connect(sign_birth)

func _process(delta: float) -> void:
	_count_second(delta)
	_count_day(delta)

##############################################################


func _count_day(delta :float) -> void :
	time_count += delta
	if time_count < time_simulation_day:
		return
	day_passed += 1
	#print("day: ",day_passed)
	time_count -= time_simulation_day
	CoreSignal.day_pass.emit()
	death_handler()
	print("*******************************")
		
func _count_second(delta :float) -> void:
	second_count += delta
	second += delta
	if second_count <= 1.0:
		return
	second_count -= 1.0
	CoreSignal.current_second.emit(second)
	
func sign_birth(agent :Node, life_span :int) -> void:
	if death_list.has(day_passed + life_span):
		death_list[day_passed + life_span].append(agent)
	else :
		death_list[day_passed + life_span] = [agent]

func death_handler() -> void:
	if not death_list.has(day_passed):
		return
	for agent in death_list[day_passed]:
		if is_instance_valid(agent):
			agent.die()
	death_list.erase(day_passed)
	
	
	
