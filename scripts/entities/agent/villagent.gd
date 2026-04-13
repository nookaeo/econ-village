extends CharacterBody2D
class_name Villagent

@export var tile_map :TileMapLayer
@export var genetics :Genetics
@export var passive_energy_multiplier :float = 10
@export var energy_drain_multiplier :float = 0.5
@onready var sprite :Sprite2D = %Sprite

var sex :String
var lifespan :int
var max_strength :float 
var max_active_energy :float
var max_passive_energy :float
var base_speed :float
var energy_drain_rate :float

var age :int = 0
var strength :float = 0
var active_energy :float = 0
var passive_energy :float = 0
#var

var target_position :Vector2 = Vector2.ZERO
var is_moving: bool = false

#//////////////////////////////////////////////////////////////////////////////#
func _ready() -> void:
	var current_tile := tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(current_tile)
	stats_init()
	print(sex," lifespan:",lifespan," max_strength:",max_strength," max_active_energy:",max_active_energy," max_passive_energy:",max_passive_energy," energy_drain_rate:",energy_drain_rate," base_speed:",base_speed)
	
func _physics_process(delta :float) -> void:
	if is_moving:
		global_position = global_position.move_toward(target_position, base_speed * delta)
		if global_position == target_position:
			is_moving = false

#///////////////////////////////////////////////////////////////////////////#

func stats_init() -> void:
	var status_multiplier :float
	var strength_base :float = genetics.sex.first.strength_base + genetics.sex.second.strength_base
	var sry_gene_power :float = genetics.sex.first.sry_gene_power + genetics.sex.second.sry_gene_power
	var lifespan_base :int = genetics.sex.first.lifespan + genetics.sex.second.lifespan
	
	if genetics.sex.first.sry_gene_power + genetics.sex.second.sry_gene_power > 0 :
		status_multiplier = 1
		sex = "male"
		if genetics.sex.first.sry_gene_power > 0:
			sprite.texture = genetics.sex.first.kid_texture
		else:
			sprite.texture = genetics.sex.second.kid_texture
	else:
		status_multiplier = 0.5
		sex = "female"
		sprite.texture = genetics.sex.first.kid_texture
		
	lifespan = int(lifespan_base * (1 - (sry_gene_power * 0.25)) * status_multiplier)
	max_strength = strength_base * (1 + sry_gene_power) * status_multiplier
	max_active_energy = max_strength
	max_passive_energy = floorf(max_strength * passive_energy_multiplier)
	energy_drain_rate = floorf(max_strength * energy_drain_multiplier)
	base_speed = clamp(floorf(400 - ((max_strength - 200) ** 2) / 200),0,500)
	
	
func move_to_grid(tile_coords :Vector2i) -> void:
	target_position = tile_map.map_to_local(tile_coords)
	is_moving = true
	
func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		var clicked_tile = tile_map.local_to_map(get_global_mouse_position())
		move_to_grid(clicked_tile)
