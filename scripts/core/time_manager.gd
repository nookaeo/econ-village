extends Node

@export var world_setting :WorldSetting
@onready var time_simulation_day :int = world_setting.time_simulation_day
var day_passed :int = 0
var time_count :float = 0
##############################################################
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	count_day(delta)

##############################################################

func count_day(delta :float) -> void :
	time_count += delta
	if time_count >= time_simulation_day:
		day_passed += 1
		time_count -= time_simulation_day
		print("day: ",day_passed)
		
	
