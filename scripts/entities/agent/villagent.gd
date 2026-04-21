extends CharacterBody2D
class_name Villagent

const rate :float = 1.0
@onready var sprite :Sprite2D = %Sprite
@onready var time_simulation_day :float = CoreConstant.time_simulation_day

#Base variables
var tile_map :TileMapLayer
@export var genetics :Genetics
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
var weight :float = 0.0

var target_position :Vector2 = Vector2.ZERO
var is_moving: bool = false
#Item variables
var inventory :Dictionary = {}
var tools :Dictionary = {}

var home :House

#//////////////////////////////////////////////////////////////////////////////#

func _ready() -> void:
	var current_tile :Vector2i = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(current_tile)
	
	CoreSignal.birth.emit(self, lifespan)
	CoreSignal.day_pass.connect(_aging)
	_base_stats_init()
	_stats_calculate()
	set_energy()
	_change_texture()
	#_dump_stats()

func _process(delta: float) -> void:
	_drain_passive_energy(delta)
	
func _physics_process(delta :float) -> void:
	if is_moving:
		global_position = global_position.move_toward(target_position, base_speed * delta)
		if global_position == target_position:
			is_moving = false
			
func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var clicked_tile = tile_map.local_to_map(get_global_mouse_position())
		_move_to_grid(clicked_tile)
#///////////////////////////////////////////////////////////////////////////#

func _base_stats_init() -> void:
	var status_average_index :float
	var sum_strength_base :float = genetics.sex.first.strength_base + genetics.sex.second.strength_base
	sum_sry_gene_power = genetics.sex.first.sry_gene_power + genetics.sex.second.sry_gene_power
	var base_lifespan :int = genetics.sex.first.lifespan + genetics.sex.second.lifespan
	var base_kid_phase :int = genetics.sex.first.kid_phase + genetics.sex.second.kid_phase
	
	if genetics.sex.first.sry_gene_power + genetics.sex.second.sry_gene_power > 0 :
		status_average_index = 1
		sex = "male"
		if genetics.sex.second.sry_gene_power > 0:
			sprite.texture = genetics.sex.second.kid_texture
		else:
			sprite.texture = genetics.sex.first.kid_texture
	else:
		status_average_index = 0.5
		sex = "female"
		sprite.texture = genetics.sex.first.kid_texture
	add_to_group(sex)
	lifespan = int(base_lifespan * (rate - (sum_sry_gene_power * 0.25)) * status_average_index)
	kid_phase = int(base_kid_phase * status_average_index)
	max_strength =sum_strength_base * (rate + sum_sry_gene_power) * status_average_index
	
	
func _stats_calculate() -> void:
	strength = floorf(max_strength * (0.1 + (age / kid_phase) * 0.9)) 
	energy_drain_rate = floorf(strength * energy_drain_multiplier)
	base_speed = floorf(clamp(floorf(500 - ((strength - 200) ** 2) / 90),0,500))
	max_active_energy = strength
	max_passive_energy = floorf(strength * passive_energy_multiplier)

func _move_to_grid(tile_coords :Vector2i) -> void:
	target_position = tile_map.map_to_local(tile_coords)
	is_moving = true
	

		
func die() -> void:
	#Inherite properties here
	#Drop items here
	self.queue_free()
	
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
	
func set_energy() -> void:
	passive_energy = max_passive_energy
	active_energy = max_active_energy
	
	
	
	
	
	
	
	
	
	
	
	
	
	
