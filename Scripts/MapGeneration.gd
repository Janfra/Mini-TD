extends Node3D

@export_category("Dependencies")
@export var grid_generation: GridComponent
@export var path_generation: EnemyPathComponent

@export_category("Configuration")
@export var grid_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_map_grid()
	if not grid_generation.has_generated:
		assert(false, "The grid was not generated")
		return
	
	_setup_map_enemy_path()
	

func _create_map_grid() -> void:
	grid_generation.grid_width = grid_size.x
	grid_generation.grid_length = grid_size.y
	grid_generation.generate_grid()
	

func _setup_map_enemy_path() -> void:
	var path_endings: Array[GridComponent.CellHandle] = grid_generation.get_random_opposing_border_cells()
	path_generation.add_to_path_given_locations(grid_generation.get_cells_positions(path_endings))
	print("Point count: %s, lenght: %s" % [path_generation.curve.point_count, path_generation.curve.get_baked_length()])
	
	# TEST: For diferrentiating end and beginning of path
	for path_ending in path_endings:
		grid_generation.get_cell_mesh(path_ending).transparency = 0.5
		
	
