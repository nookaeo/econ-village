extends CharacterBody2D
class_name Villagent

const rate :float = 1.0
@onready var sprite :Sprite2D = %Sprite
@onready var time_simulation_day :float = CoreConstant.time_simulation_day

#Base variables
var tile_map :TileMapLayer
@export var genetics :Genetics
@export var rule :Dictionary = {"FoodStock": 0.0,"WoodStock": 0.0}
var passive_energy_multiplier :float = 10
var energy_drain_multiplier :float = 0.5
var sex :String
var lifespan :int
var kid_phase :float
var max_strength :float 
var max_active_energy :float
var max_passive_energy :float
var sum_sry_gene_power :float

var age :int = 0
var strength :float = 0.0
var active_energy :float = 0.0
var passive_energy :float = 0.0
var energy_drain_rate :float = 0.0
var base_speed :float = 0.0
var weight_handle :float = 0.0
var weight :float = 0.0
var patience_index :float = 0.0
var day_time :float = 0.0
var work_time :float = 0.0
var is_tired :bool = false

var target_position :Vector2 = Vector2.ZERO
var is_moving: bool = false
#Item variables
var inventory :Dictionary = {}
var tools :Dictionary = {}

var home :House = null
var role :Dictionary = {"male":["Food","Wood","Shell"],"female":["Food","Shell","Shipping"]}
var partner :Villagent = null

#statistics
var gather_count :Dictionary = {}
var gather_statistic :Dictionary = {}

var market_id :int = 0
#//////////////////////////////////////////////////////////////////////////////#


	
func _ready() -> void:
	
	var current_tile :Vector2i = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(current_tile)
	CoreSignal.current_second.connect(_count_time)
	CoreSignal.birth.emit(self, lifespan)
	CoreSignal.day_pass.connect(_pass_day)
	_base_stats_init()
	_stats_calculate()
	set_energy()
	_change_texture()
	#_dump_stats()

func _process(delta: float) -> void:
	_drain_passive_energy(delta)
	
func _physics_process(delta :float) -> void:
	var strength_index :float = strength / 100.0
	var hardness :float = 1
	
	if is_moving:
		global_position = global_position.move_toward(target_position, base_speed * delta)
		active_energy -= delta * strength_index * hardness
		if global_position == target_position:
			is_moving = false
			
#///////////////////////////////////////////////////////////////////////////#

func _pass_day() -> void:
	_aging()
	_calculate_statistic()

func _base_stats_init() -> void:
	var first_sex_chromosomes :SexChromosome = genetics.sex.first
	var second_sex_chromosomes :SexChromosome = genetics.sex.second
	var status_average_index :float
	var sum_strength_base :float = first_sex_chromosomes.strength_base + second_sex_chromosomes.strength_base
	sum_sry_gene_power = first_sex_chromosomes.sry_gene_power + second_sex_chromosomes.sry_gene_power
	var sum_lifespan :int = first_sex_chromosomes.lifespan + second_sex_chromosomes.lifespan
	var sum_kid_phase :int = first_sex_chromosomes.kid_phase + second_sex_chromosomes.kid_phase
	var sum_patience_index :float = first_sex_chromosomes.patience_index + second_sex_chromosomes.patience_index
	if first_sex_chromosomes.sry_gene_power + second_sex_chromosomes.sry_gene_power > 0 :
		status_average_index = 1
		sex = "male"
		if second_sex_chromosomes.sry_gene_power > 0:
			sprite.texture = second_sex_chromosomes.kid_texture
		else:
			sprite.texture = first_sex_chromosomes.kid_texture
	else:
		status_average_index = 0.5
		sex = "female"
		sprite.texture = first_sex_chromosomes.kid_texture
		
	add_to_group(sex)
	lifespan = int(sum_lifespan * (rate - (sum_sry_gene_power * 0.25)) * status_average_index)
	kid_phase = int(sum_kid_phase * status_average_index)
	max_strength = sum_strength_base * (rate + sum_sry_gene_power) * status_average_index
	patience_index = sum_patience_index * status_average_index
	#patience_index = 
	
func _stats_calculate() -> void:
	strength = floorf(max_strength * (0.1 + (age / kid_phase) * 0.9)) 
	energy_drain_rate = floorf(strength * energy_drain_multiplier)
	base_speed = floorf(clamp(floorf(400 - ((strength - 200) ** 2) / 200),0,1000))
	max_active_energy = strength
	max_passive_energy = floorf(strength * passive_energy_multiplier)
	weight_handle = floorf(strength / 4.0)
	
func _move_to_grid(tile_coords :Vector2i) -> void:
	target_position = tile_map.map_to_local(tile_coords)
	is_moving = true
	
	
func _aging() -> void:
	age += 1
	if age <= kid_phase:
		_stats_calculate()
	#_dump_stats()
	_change_texture()
	
func _change_texture():
	if age == kid_phase:
		if genetics.sex.first.sry_gene_power > 0:
			sprite.texture = genetics.sex.first.adult_texture
		else:
			sprite.texture = genetics.sex.second.adult_texture
	
func _dump_stats():
	print(sex," age:",age,"/",lifespan," kid_phase:",kid_phase," strength:",strength,"/",max_strength," active_energy:",active_energy,"/",max_active_energy," passive_energy:",passive_energy,"/",max_passive_energy," energy_drain_rate:",energy_drain_rate," base_speed:",base_speed)


func _drain_passive_energy(_delta :float) -> void:
	var enrgy_drain :float = (energy_drain_rate * _delta) / time_simulation_day
	if passive_energy >= enrgy_drain:
		passive_energy -= enrgy_drain
	else :
		die()
		
func calculate_weight() -> void:
	weight = 0
	if inventory.size() <= 0 :
		return
	for item in inventory:
		weight += inventory[item] * ItemData.items[item]["weight"]
		
func add_item(item_name :ItemData.ItemName,amount :int) -> void:
	if not inventory.has(item_name):
		inventory[item_name] = 0
	inventory[item_name] += amount
	calculate_weight()

func remove_item(item_name :ItemData.ItemName,amount :int):
	if not inventory.has(item_name):
		return
	if inventory[item_name] < amount:
		return
	inventory[item_name] -= amount
	calculate_weight()

func store_item_to_home() -> void:
	if home == null:
		return
	if home.house_level < 1:
		return
	if inventory.size() < 1:
		return
	for item in inventory:
		if not home.house_storage.has(item):
			home.house_storage[item] = 0
		home.house_storage[item] += inventory[item]
	inventory.clear()
	calculate_weight()
	home.calculate_weight()
	return
	
	
func die() -> void:
	#Inherite properties here
	#Drop items here
	self.queue_free()
	
func set_energy() -> void:
	passive_energy = max_passive_energy
	active_energy = max_active_energy
	
func count_gather_resource(item_id :ItemData.ItemName, amount :int) -> void:
	if amount <= 0:
		return
		
	if not gather_count.has(item_id):
		gather_count[item_id] = 0
	gather_count[item_id] += amount
	
func _calculate_statistic() -> void:
	if gather_count.size() < 1:
		return
	for item in gather_count:
		if not gather_statistic.has(item):
			gather_statistic[item] = [] 
		#day_stats[item] = gather_count[item]
		gather_statistic[item].push_front(gather_count[item])
		if gather_statistic[item].size() > 7:
			gather_statistic[item].resize(7)
	gather_count.clear()

func _count_time(world_second :int) -> void:
	day_time = world_second % int(time_simulation_day)
		
	
	
	
	
	
	
	
	
	
	
