extends Node3D

@export_category("Generation Components")
@export var grid_generation: GridGenerator
@export var path_generation: EnemyPathGenerator

@export_category("Configuration")
@export var grid_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_generation.grid_width = grid_size.x
	grid_generation.grid_length = grid_size.y
	grid_generation.generate_grid()
	var path_endings: Array[HolderComponent] = grid_generation.get_random_opposing_border_cells()
	path_generation.add_to_path_given_locations(_get_location_from_holders(path_endings))
	print("Point count: %s, lenght: %s" % [path_generation.curve.point_count, path_generation.curve.get_baked_length()])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _get_location_from_holders(holders : Array[HolderComponent]) -> Array[Vector3]:
	var positions: Array[Vector3]
	for holder in holders:
		positions.append(holder.global_position)
		holder._mesh.transparency = 0.5
	
	return positions
