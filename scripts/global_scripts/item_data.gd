extends Node
enum ToolType {MULTIPURPOSE , AXE, PICAXE, HOE }

var items = {
	0: {
	"name": "cowrie shell",
	"weight": 0,
	},
	1: {
	"name": "wood",
	"weight": 1.0,
	
	},
	2: {
	"name": "stone",
	"weight": 2.0,
	
	},
	3: {
	"name": "fish",
	"weight": 0.5,
	"energy": 20
	},
	4: {
	"name": "stone axe",
	"weight": 2.0,
	"tool_type": ToolType.MULTIPURPOSE,
	"tool_level": 0,
	"durability": 10,  
	"materials": {1:2,2:1},
	},
	5: {
	"name": "bronze axe",
	"weight": 2.0,
	"tool_type": ToolType.MULTIPURPOSE,
	"tool_level": 1,
	"durability": 10,  
	"materials": {1:2,2:1},
	},
}
