extends Panel
var day :int = 1

func _ready() -> void:
	%ProgressBar.max_value = CoreConstant.time_simulation_day
	self.visible = false
	_stats_update()
	%MenuButton.pressed.connect(func open_mennu():
		self.visible = ! self.visible
		)
	CoreSignal.day_pass.connect(_stats_update)
	CoreSignal.current_second.connect(_second_show)
	
func _process(_delta: float) -> void:
	pass
	
func _second_show(second :float) -> void:
	%TimeSecond.text = str(int(second)," s")
	var sim_hours :int = int(second) % CoreConstant.time_simulation_day
	%ProgressBar.value = sim_hours
	%SimHours.text = str(sim_hours)
	
func _stats_update() -> void:
	await get_tree().create_timer(0.1).timeout
	var agents :Array = get_tree().get_nodes_in_group("Villagent")
	var agent_males :Array = get_tree().get_nodes_in_group("male")
	var agent_females :Array = get_tree().get_nodes_in_group("female")
	var trees :Array = get_tree().get_nodes_in_group("Tree")
	var stones :Array = get_tree().get_nodes_in_group("Stones")
	var fish :Array = get_tree().get_nodes_in_group("Fish")
	%Population.text = str("Population: " ,agents.size(),"/",agent_males.size(),"/",agent_females.size())
	%Time.text = str("Day: ",day)
	%Trees.text = str("Trees: ",trees.size())
	%Stones.text = str("Stones: ",stones.size())
	%Fish.text = str("Fish: ",fish.size())
	day += 1
