extends Node


var items = {
	Enums.ItemId.Shells: {
	"name": "cowrie shell",
	"weight": 0,
	},
	Enums.ItemId.Wood: {
	"name": "wood",
	"weight": 1.0,
	
	},
	Enums.ItemId.Stone: {
	"name": "stone",
	"weight": 2.0,
	
	},
	Enums.ItemId.Fish: {
	"name": "fish",
	"weight": 0.5,
	"energy": 10.0
	},
	Enums.ItemId.StoneAxe: {
	"name": "stone axe",
	"weight": 2.0,
	"tool_type": Enums.ToolType.MULTIPURPOSE,
	"craft_time": 8,
	"tool_level": 0,
	"durability": 10,  
	"materials": {Enums.ItemId.Wood:2,Enums.ItemId.Stone:1},
	},
	Enums.ItemId.BronzeAxe: {
	"name": "bronze axe",
	"weight": 2.0,
	"tool_type": Enums.ToolType.AXE,
	"craft_time": 8,
	"tool_level": 1,
	"durability": 20,  
	"materials": {Enums.ItemId.Wood:2,Enums.ItemId.Stone:1},
	},
}
