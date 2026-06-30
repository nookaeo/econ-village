extends Panel


func _ready() -> void:
	self.visible = false
	%MarketButton.pressed.connect(func open_mennu():
		self.visible = !self.visible
		%MainMenu.visible = false
		)
	MarketSignal.market_updated.connect(_market_update)


func _market_update(market_orders :Dictionary) -> void :
	var fish_order_displays = %FishOrderList.get_children()
	var wood_order_displays = %WoodOrderList.get_children()
	var sort_prices_list :Dictionary = {}
	var display_list :Dictionary = {}
	for item in market_orders:
		for price in market_orders[item]:
			if not sort_prices_list.has(item):
				sort_prices_list[item] = []
			sort_prices_list[item].append(price)
			if not display_list.has(item):
				display_list[item] = {}
			if not display_list[item].has(price):
				display_list[item][price] = 0
			for order in  market_orders[item][price]:
				display_list[item][price] += market_orders[item][price][order]["amount"]
		sort_prices_list[item].sort()

	for label in fish_order_displays:
		label.text = ""
	for label in wood_order_displays:
		label.text = ""
	if display_list.has(Enums.ItemId.Fish):
		var i :int = 0
		for price in sort_prices_list[Enums.ItemId.Fish]:
			if i == fish_order_displays.size():
				continue
			fish_order_displays[i].text = str(display_list[Enums.ItemId.Fish][price]," / ",price)
			i += 1
	if display_list.has(Enums.ItemId.Wood):
		var i :int = 0
		for price in sort_prices_list[Enums.ItemId.Wood]:
			if i == wood_order_displays.size():
				continue
			wood_order_displays[i].text = str(display_list[Enums.ItemId.Wood][price]," / ",price)
			i += 1
