extends Panel
var day :int = 1
var total_cowrie :int = 0
var cowrie_day :int = 0
var market :Market = null
var houses :Array
var houses_strategy :Dictionary
var chart :Chart
var goods_amount_chart :Chart
var cowrie_chart :Chart

var fish_price :Function
var wood_price :Function
var cowrie_data :Function
var fish_amount :Function
var wood_amount :Function

func _ready() -> void:
	market = get_tree().get_first_node_in_group("Market")
	
	_chart_init()
	
	%ProgressBar.max_value = CoreConstant.time_simulation_day
	self.visible = false
	
	_stats_update()
	
	%MenuButton.pressed.connect(func open_mennu():
		self.visible = !self.visible
		%Market.visible = false
		)
		
	CoreSignal.day_pass.connect(_day_pass)
	
	CoreSignal.current_second.connect(_second_show)
	
	Statistic.nat_resource_pick.connect(func( item_id :Enums.ItemId, amount:int):
		match item_id:
			Enums.ItemId.Shells:
				total_cowrie += amount
				cowrie_day += amount
		)
		
	
		
		
func _update_agents_strategy() -> void:
	houses = get_tree().get_nodes_in_group("House")
	
	for strategy in Enums.Strategy.keys():
		houses_strategy[strategy] = 0
		
	for house :House in houses:
		var key :String = Enums.Strategy.keys()[house.strategy_mode]
		if not houses_strategy.has(key):
			houses_strategy[key] = 0
		houses_strategy[key] += 1
	
	%Strategy.text = var_to_str(houses_strategy)
	
func _day_pass() -> void:
	_stats_update()
	if fish_price.count_points() > 180:
		fish_price.pop_front_point()
		wood_price.pop_front_point()
		fish_amount.pop_front_point()
		wood_amount.pop_front_point()
		
	
	if cowrie_data.count_points() > 30:
		cowrie_data.pop_front_point()
		
	if market :
		fish_price.add_point(day,float(market.get_information()[Enums.ItemId.Fish]["LastPrice"]))
		wood_price.add_point(day,float(market.get_information()[Enums.ItemId.Wood]["LastPrice"]))
		fish_amount.add_point(day,float(market.get_information()[Enums.ItemId.Fish]["LeftOver"]))
		wood_amount.add_point(day,float(market.get_information()[Enums.ItemId.Wood]["LeftOver"]))
		
	
		
	cowrie_data.add_point(day,float(cowrie_day))
	chart.queue_redraw()
	goods_amount_chart.queue_redraw()
	cowrie_chart.queue_redraw()
	cowrie_day = 0
	
	_update_agents_strategy()
	
	
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
	%TotalCowrie.text = str("Total Cowrie: ",total_cowrie)
	day += 1
	
func _chart_init() -> void:
	chart = %Chart
	cowrie_chart = %ChartCowrie
	goods_amount_chart = %GoodsAmount
	fish_price = Function.new(
		[0,0],  # The function's X-values
		[0,0], # The function's Y-values
		"Fish",       # The function's name
		{
			type = Function.Type.LINE,       # The function's type
			#marker = Function.Marker.SQUARE, # Some function types have additional configuraiton
			color = Color("#36a2eb"),        # The color of the drawn function
			
		}
	)
	wood_price = Function.new(
		[0,0],  # The function's X-values
		[0,0], # The function's Y-values
		"Wood",       # The function's name
		{
			type = Function.Type.LINE,       # The function's type
			#marker = Function.Marker.CIRCLE, # Some function types have additional configuraiton
			color = Color("388e00ff"),        # The color of the drawn function
		}
	)
	fish_amount = Function.new(
		[0,0],  # The function's X-values
		[0,0], # The function's Y-values
		"Fish",       # The function's name
		{
			type = Function.Type.LINE,       # The function's type
			#marker = Function.Marker.CIRCLE, # Some function types have additional configuraiton
			color = Color("#36a2eb"),        # The color of the drawn function
		}
	)
	wood_amount = Function.new(
		[0,0],  # The function's X-values
		[0,0], # The function's Y-values
		"Wood",       # The function's name
		{
			type = Function.Type.LINE,       # The function's type
			#marker = Function.Marker.CIRCLE, # Some function types have additional configuraiton
			color = Color("388e00ff"),        # The color of the drawn function
		}
	)
	
	cowrie_data = Function.new(
		[0,0],  # The function's X-values
		[0,0], # The function's Y-values
		"Cowrie",       # The function's name
		{
			type = Function.Type.LINE,       # The function's type
			#marker = Function.Marker.CIRCLE, # Some function types have additional configuraiton
			color = Color("b19400ff"),        # The color of the drawn function
		}
	)
	
	var chart_properties := ChartProperties.new()
	chart_properties.x_label = ""
	chart_properties.y_label = ""
	chart_properties.title = "Price Chart"
	chart_properties.show_legend = true
	chart_properties.max_samples = 720
	chart_properties.draw_origin = false
	
	var goods_amount_chart_properties := ChartProperties.new()
	goods_amount_chart_properties.x_label = ""
	goods_amount_chart_properties.y_label = ""
	goods_amount_chart_properties.title = "Amount Chart"
	goods_amount_chart_properties.show_legend = true
	goods_amount_chart_properties.max_samples = 720
	goods_amount_chart_properties.draw_origin = false
	
	var chart_properties_cowrie := ChartProperties.new()
	chart_properties_cowrie.x_label = ""
	chart_properties_cowrie.y_label = ""
	chart_properties_cowrie.title = "Cowrie Chart"
	chart_properties_cowrie.show_legend = false
	chart_properties_cowrie.max_samples = 720
	chart_properties_cowrie.draw_origin = false
	
	chart.plot([fish_price,wood_price], chart_properties)
	goods_amount_chart.plot([fish_amount,wood_amount], goods_amount_chart_properties)
	cowrie_chart.plot([cowrie_data], chart_properties_cowrie)
