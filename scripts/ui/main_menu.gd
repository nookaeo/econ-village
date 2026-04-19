extends Panel
var day :int = 1

func _ready() -> void:
	self.visible = false
	_stats_update()
	%MenuButton.pressed.connect(func open_mennu():
		self.visible = ! self.visible
		)
	CoreSignal.day_pass.connect(_stats_update)

func _process(_delta: float) -> void:
	pass
	
func _stats_update():
	await get_tree().create_timer(0.1).timeout
	var agents :Array = get_tree().get_nodes_in_group("Villagent")
	var agent_males :Array = get_tree().get_nodes_in_group("male")
	var agent_females :Array = get_tree().get_nodes_in_group("female")
	%Population.text = str("Population: " ,agents.size(),"/",agent_males.size(),"/",agent_females.size())
	%Time.text = str("Day: ",day)
	day += 1
