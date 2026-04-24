extends Node
enum ToolType {NONE, MULTIPURPOSE, AXE, PICAXE, HOE }
enum ItemName {Shells,Wood,Stone,Fish,StoneAxe,BronzeAxe}

var items = {
	ItemName.Shells: {
	"name": "cowrie shell",
	"weight": 0,
	},
	ItemName.Wood: {
	"name": "wood",
	"weight": 1.0,
	
	},
	ItemName.Stone: {
	"name": "stone",
	"weight": 2.0,
	
	},
	ItemName.Fish: {
	"name": "fish",
	"weight": 0.5,
	"energy": 20.0
	},
	ItemName.StoneAxe: {
	"name": "stone axe",
	"weight": 2.0,
	"tool_type": ToolType.MULTIPURPOSE,
	"craft_time": 8,
	"tool_level": 0,
	"durability": 10,  
	"materials": {ItemName.Wood:2,ItemName.Stone:1},
	},
	ItemName.BronzeAxe: {
	"name": "bronze axe",
	"weight": 2.0,
	"tool_type": ToolType.AXE,
	"craft_time": 8,
	"tool_level": 1,
	"durability": 20,  
	"materials": {ItemName.Wood:2,ItemName.Stone:1},
	},
}
