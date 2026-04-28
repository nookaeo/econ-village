extends Node2D
class_name Market
var agent_id_count :int = 1
var sell_order :Dictionary = {}
var sort_sell_order :Dictionary = {}
var last_trade_price :Dictionary = {}
var seller_balances :Dictionary = {}
var order_id :int = 1
#////////////////////////////////////////////////////////////////////////////////
func _ready() -> void:
	CoreSignal.day_pass.connect(_update_market)

func _process(_delta: float) -> void:
	pass
#////////////////////////////////////////////////////////////////////////////////

func _update_market():
	sort_sell_order.clear()
	_sort_sell_order()
	print(sort_sell_order)

func signin_market_id(agent :Villagent):
	if agent.market_id > 0:
		return
	seller_balances[agent_id_count] = 0
	agent.market_id = agent_id_count
	agent_id_count += 1
	
func create_sell_order(seller :Villagent ,item :ItemData.ItemName, amount :int, price :int) -> bool:
	if not seller.inventory.has(item):
		return false
	if not seller.inventory[item] < amount:
		return false
	sell_order[order_id] = {"seller":seller.market_id,"item":item,"price":price, "amount":amount}
	order_id += 1
	seller.inventory[item] -= amount
	return true

func _sort_sell_order():
	if sell_order.size() <= 0:
		return
	for _order_id in sell_order:
		var order :Dictionary = sell_order[_order_id]
		var seller :int = order["seller"]
		var item :ItemData.ItemName = order["item"]
		var price :int = order["price"]
		var amount :int = order["amount"]
		
		if not sort_sell_order.has(item):
			sort_sell_order[item] = {}
		if not sort_sell_order[item].has(price):
			sort_sell_order[item][price] = {}
		sort_sell_order[item][price][_order_id] = {"seller":seller, "amount":amount}
	
func buy(buyer :Villagent, item :ItemData.ItemName, buy_amount :float) -> bool:
	var cheapest_price :float = _find_cheapest(item)
	if not sort_sell_order.has(item):
		return false
	if sort_sell_order[item].size() <= 0:
		return false
	if cheapest_price <= 0:
		return false
	if not buyer.inventory.has(ItemData.ItemName.Shells):
		return false
	if buyer.inventory[ItemData.ItemName.Shells] < cheapest_price :
		return false
		
	while buy_amount > 0:
		cheapest_price = _find_cheapest(item)
		for _order_id in sort_sell_order[item][cheapest_price]:
			if buy_amount <= 0 :
				return true
			if sort_sell_order[item][cheapest_price].size() <= 0:
				break
			var amount :float = min(buy_amount,sort_sell_order[item][cheapest_price][_order_id]["amount"])
			var pay :float = amount * cheapest_price
			if buyer.inventory[ItemData.ItemName.Shells] < pay  :
				return true
			
			sort_sell_order[item][cheapest_price][_order_id]["amount"] -= amount
			sell_order[_order_id]["amount"] -= amount
			buy_amount -= amount
			buyer.add_item(item, int(amount))
			
			buyer.remove_item(ItemData.ItemName.Shells, int(pay))
			seller_balances[sort_sell_order[item][cheapest_price][_order_id]["seller"]] += pay
			
			if sort_sell_order[item][cheapest_price][_order_id]["amount"] <= 0:
				sort_sell_order[item][cheapest_price].erase(_order_id)
				sell_order.erase(_order_id)
				
				if sort_sell_order[item][cheapest_price].size() <= 0:
					sort_sell_order[item].erase(cheapest_price)
				break
				
	return true


func _find_cheapest(item :ItemData.ItemName) -> float:
	var cheapest_price :float = INF
	if not sell_order.has(item):
		return 0.0
	if not sell_order[item].size() <= 0:
		return 0.0
	
	for price in sell_order[item] :
		if sell_order[item][price].size() <= 0:
			continue
		if price < cheapest_price:
			cheapest_price = price
	return cheapest_price
	
func get_information(item :ItemData.ItemName) -> Dictionary:
	var orders :Dictionary = sort_sell_order.duplicate(true)
	var information :Dictionary = {}
	var _item_amount :float = 0.0
	var cheapest_price :float = _find_cheapest(item)
	
	for order in sell_order[item][cheapest_price]:
		_item_amount += order["amount"]
	if orders.has(item) and last_trade_price.has(item):
		information.assign({"LastPrice":last_trade_price[item],"Cheapest":cheapest_price,"SellAmount":_item_amount})
	
	
	return information.duplicate(true)
	
	
