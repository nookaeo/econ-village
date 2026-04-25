extends Node2D
var sell_order :Dictionary = {}
var last_trade_price :Dictionary = {}

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func create_sell_order(seller :Villagent ,item :ItemData.ItemName, amount :int, price :int) -> bool:
	if not sell_order.has(item):
		sell_order[item] = []
	sell_order[item].append({"seller":seller, "amount":amount, "price":price})
	
	return true
	
func buy(_item :ItemData.ItemName, _amount :int,) -> bool:
	return true
	
func get_information(item :ItemData.ItemName) -> Dictionary:
	var orders :Dictionary = sell_order.duplicate(true)
	var information :Dictionary = {}
	if orders.has(item) and last_trade_price.has(item):
		information.assign({"LastPrice":last_trade_price[item]})
	return information
	
	
