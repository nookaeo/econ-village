extends BTAction
var gathers_day :Dictionary = {}
func tick(_actor: Node, _blackboard :Node) -> Status:
	var agent :Villagent = _actor
	#var blackboard :Blackboard = _blackboard
	var resource_gather_worth :Dictionary = {}
	var household_resource_consumed :Dictionary = agent.home.avg_household_resource_consumed_day
	var resource_consumed_worth :float = 0
	var best_resource :Enums.ItemId
	var price_change_sensitivity :float = 0.5
	var base_magin :float = 0.2
	var margin :float = 0.0
	
	# and agent.gather_statistic[resource_id] >= household_resource_consumed[resource_id] * household_resource_consumed.size() 
	for resource_id in household_resource_consumed:
		if not household_resource_consumed.has(resource_id):
			break
		if not agent.home.market_data.has(resource_id):
			break
		resource_consumed_worth += household_resource_consumed[resource_id] * agent.home.market_data[resource_id]["LastPrice"]

	for resource_id in agent.gather_statistic:
		var resource_gather :float = Math.find_median(agent.gather_statistic[resource_id])
		gathers_day[resource_id] = resource_gather
	for resource_id in agent.gather_statistic:
		var resource_gather :float = Math.find_median(agent.gather_statistic[resource_id])
		
		if resource_consumed_worth <= 0 :
			break
		
		var resource_consumed :float = 0
		var resource_price :float = 0
		
		if resource_id != Enums.ItemId.Shells and agent.home.market_data[resource_id]["SellAmount"] > 0:
			resource_price = agent.home.market_data[resource_id]["LastPrice"]
			
		elif resource_id != Enums.ItemId.Shells and agent.home.market_data[resource_id]["SellAmount"] == 0 and agent.home.market_data[resource_id]["LastPrice"] > 0:
			resource_price = agent.home.market_data[resource_id]["LastPrice"] * 1.1
			
		elif resource_id != Enums.ItemId.Shells and agent.home.market_data[resource_id]["SellAmount"] == 0 and agent.home.market_data[resource_id]["LastPrice"] == 0 : 
			if agent.gather_statistic.has(Enums.ItemId.Shells) and agent.gather_statistic.has(resource_id):
				resource_price = int((float(Math.find_median(agent.gather_statistic[Enums.ItemId.Shells])) / float(Math.find_median(agent.gather_statistic[resource_id])))*2)
			else :
				resource_price = 1
				
		if resource_id == Enums.ItemId.Shells:
			resource_gather_worth[resource_id] = resource_gather
		elif household_resource_consumed.has(resource_id) :
			resource_consumed = ceilf(household_resource_consumed[resource_id])
			resource_gather_worth[resource_id] = floorf(((resource_gather - resource_consumed ) * resource_price) - (resource_consumed_worth - (resource_price * resource_consumed)))
		else:
			resource_gather_worth[resource_id] = floorf((resource_gather * resource_price) - resource_consumed_worth)
		
	#find best resource to gather as a main job.
	var best_worth :float = -INF
	for resource_id in resource_gather_worth :
		var worth :float = resource_gather_worth[resource_id]
		if worth > best_worth:
			best_worth = worth
			best_resource = resource_id
			
	margin = best_worth / resource_consumed_worth
	#print(gathers_day)
	agent.home.ordering_info = {
		"resources_ratio":gathers_day,
		"base_margin":base_magin,
		"margin":margin,
		"sensitivity":price_change_sensitivity 
	}
	agent.home.strategy_mode = Enums.Strategy.SelfSufficient
	if margin > base_magin and is_instance_valid(agent.partner) :
		if  agent.partner != null:
			match best_resource:
				Enums.ItemId.Shells:
					if agent.home.market_data[Enums.ItemId.Fish]["LeftOver"] > 0 and agent.home.market_data[Enums.ItemId.Wood]["LeftOver"] > 0:
						agent.home.strategy_mode = Enums.Strategy.ShellFinder
						agent.count_gather_resource(Enums.ItemId.Shells, 0)
						
				Enums.ItemId.Wood:
					if agent.home.market_data[Enums.ItemId.Fish]["LeftOver"] > 0:
						agent.home.strategy_mode = Enums.Strategy.Lumberjack
						agent.count_gather_resource(Enums.ItemId.Wood, 0)
						
				Enums.ItemId.Fish:
					if agent.home.market_data[Enums.ItemId.Wood]["LeftOver"] > 0:
						agent.home.strategy_mode = Enums.Strategy.FishCatcher
						agent.count_gather_resource(Enums.ItemId.Fish, 0)
	
		
		
	
	agent.home.assign_role(agent)
	return Status.SUCCESS
	
