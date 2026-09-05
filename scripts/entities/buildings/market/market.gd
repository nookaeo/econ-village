extends Node2D
class_name Market
var agent_id_count :int = 1
var sell_order :Dictionary = {}
var sort_sell_order :Dictionary = {}
var current_trade_price :Dictionary = {}
var last_trade_price :Dictionary = {}
var seller_balances :Dictionary = {}
var order_id :int = 1
var left_over_order :Dictionary = {}
#////////////////////////////////////////////////////////////////////////////////
func _ready() -> void:
	CoreSignal.day_pass.connect(_update_market)

func _process(_delta: float) -> void:
	pass
#////////////////////////////////////////////////////////////////////////////////

func _update_market():
	_find_total_left_over()
	sort_sell_order.clear()
	_sort_sell_order()
	_median_price_trade()
	#print(sort_sell_order)
	print(get_information())
	MarketSignal.market_updated.emit(sort_sell_order.duplicate_deep(true))

func sign_market_id(agent :Villagent):
	if agent.market_id > 0:
		return
	seller_balances[agent_id_count] = 0
	agent.market_id = agent_id_count
	agent_id_count += 1
	
func create_sell_order(seller :Villagent ,item :Enums.ItemId, amount :int, price :int) -> bool:
	if not seller.inventory.has(item):
		return false
	if seller.inventory[item] < amount:
		return false
		
	sell_order[order_id] = {"seller":seller.market_id,"item":item,"price":price, "amount":amount}
	order_id += 1
	seller.remove_item(item,amount)
	return true

func _sort_sell_order():
	if sell_order.size() <= 0:
		return
	for _order_id in sell_order:
		var order :Dictionary = sell_order[_order_id]
		var seller :int = order["seller"]
		var item :Enums.ItemId = order["item"]
		var price :int = order["price"]
		var amount :int = order["amount"]
		
		if not sort_sell_order.has(item):
			sort_sell_order[item] = {}
		if not sort_sell_order[item].has(price):
			sort_sell_order[item][price] = {}
		sort_sell_order[item][price][_order_id] = {"seller":seller, "amount":amount}
	
func buy(buyer :Villagent, item :Enums.ItemId, buy_amount :float) -> void:
	var cheapest_price :int = int(_find_cheapest(item))
	if not sort_sell_order.has(item):
		#print("Test1")
		return
	if sort_sell_order[item].size() <= 0:
		#print("Test2")
		return
	
	if not buyer.inventory.has(Enums.ItemId.Shells):
		#print("Test3")
		return
	if buyer.inventory[Enums.ItemId.Shells] < cheapest_price :
		#print("Test4")
		return

	while buy_amount > 0:
		cheapest_price = int(_find_cheapest(item))
		if cheapest_price <= 0:
			break
		if buy_amount <= 0 :
			return
		for _order_id in sort_sell_order[item][cheapest_price]:
			if buy_amount <= 0 :
				return
			if not sort_sell_order[item].has(cheapest_price):
				break
				
			var amount :float = min(buy_amount, sort_sell_order[item][cheapest_price][_order_id]["amount"])
			var pay :float = amount * cheapest_price
			
			if buyer.inventory[Enums.ItemId.Shells] < pay  :
				return
			
			sort_sell_order[item][cheapest_price][_order_id]["amount"] -= amount
			sell_order[_order_id]["amount"] -= amount
			buy_amount -= amount
			buyer.add_item(item, int(amount))
			
			buyer.remove_item(Enums.ItemId.Shells, int(pay))
			seller_balances[sort_sell_order[item][cheapest_price][_order_id]["seller"]] += pay
			
			current_trade_price[item] = cheapest_price
			if sort_sell_order[item][cheapest_price][_order_id]["amount"] <= 0:
				sort_sell_order[item][cheapest_price].erase(_order_id)
				sell_order.erase(_order_id)
				
				if sort_sell_order[item][cheapest_price].size() <= 0:
					sort_sell_order[item].erase(cheapest_price)
				break
	#print(buyer.inventory)
	return


func _find_cheapest(item :Enums.ItemId) -> float:
	var cheapest_price :float = INF
	
	if not sort_sell_order.has(item):
		return 0.0
	if sort_sell_order[item].size() <= 0:
		return 0.0
	
	for price in sort_sell_order[item] :
		if sort_sell_order[item][price].size() <= 0:
			
			continue
		if price < cheapest_price:
			cheapest_price = price
			
	return cheapest_price
	
func get_information() -> Dictionary:
	var orders :Dictionary = sort_sell_order.duplicate(true)
	var information :Dictionary = {}
	for item :Enums.ItemId in Enums.ItemId.values():
		if item == 0:
			continue
		var cheapest_price :int = int(_find_cheapest(item))
		information[item] = {}
		if orders.has(item):
			information[item].merge({"Cheapest":cheapest_price})
			information[item].merge({"LeftOver":_find_left_over(item)})
		else :
			information[item].merge({"Cheapest":0})
			information[item].merge({"LeftOver":0})
			
		if last_trade_price.has(item):
			information[item].merge({"LastPrice":Math.find_median(last_trade_price[item])})
		else :
			
			information[item].merge({"LastPrice":0})
		if left_over_order.has(item):
			information[item].merge({"SellAmount":left_over_order[item]})
		else:
			information[item].merge({"SellAmount":0})

		
	
	return information.duplicate(true)
	
func withdraw_shells(agent :Villagent) -> void:
	if not seller_balances.has(agent.market_id):
		return
	if seller_balances[agent.market_id] <= 0:
		return
	agent.add_item(Enums.ItemId.Shells,seller_balances[agent.market_id])
	seller_balances[agent.market_id] = 0
	
	
func _find_total_left_over() -> void:
	var orders :Dictionary = sort_sell_order.duplicate(true)
	left_over_order.clear()
	for item :Enums.ItemId in orders:
		for price in orders[item]:
			for order in orders[item][price]:
				if not left_over_order.has(item):
					left_over_order[item] = 0
				left_over_order[item] += sort_sell_order[item][price][order]["amount"]
				

func _median_price_trade() -> void:
	for item in current_trade_price:
		if not last_trade_price.has(item):
			last_trade_price[item] = []
		last_trade_price[item].push_front(current_trade_price[item])
		if last_trade_price[item].size() > 3:
			last_trade_price[item].resize(3)
	print(last_trade_price)
	
func _find_left_over(item :Enums.ItemId) -> int:
	var amount :int = 0
	if not sort_sell_order.has(item):
		return 0
	for price in sort_sell_order[item]:
		for order in sort_sell_order[item][price]:
			amount += sort_sell_order[item][price][order]["amount"]
	return amount
	
	
	
	
	
	
	
	
	
	
	
	
	
