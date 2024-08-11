extends Node3D

@export_category("Dependencies")
@export var grid_generation: GridComponent
@export var path_generation: PathComponent
@export var main_building: PlayerMainBuilding

@export_category("Configuration")
@export var grid_size: Vector2i
@export_subgroup("Grid Path")
@export var path_straight_mesh: Mesh
@export var path_ending_mesh: Mesh
@export var path_corner_mesh: Mesh

enum FacingDirection
{
	Down,
	Right,
	Up,
	Left
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_map_grid()
	if not grid_generation.has_generated:
		assert(false, "The grid was not generated")
		return
	
	_setup_map_enemy_path()
	
	assert(main_building)
	if main_building:
		main_building.setup_building_connections(path_generation)
	

func _create_map_grid() -> void:
	grid_generation.grid_width = grid_size.x
	grid_generation.grid_length = grid_size.y
	grid_generation.generate_grid()
	

func _setup_map_enemy_path() -> void:
	var path_endings: Array[GridComponent.CellHandle] = grid_generation.get_random_opposing_border_cells()
	var path: Array[GridComponent.CellHandle] = grid_generation.get_path_from_to_cell(path_endings[0], path_endings[1])
	
	path_generation.add_to_path_given_locations(grid_generation.get_cells_positions(path))
	print("Added Count: %s, Point count: %s, lenght: %s" % [path.size(), path_generation.curve.point_count, path_generation.curve.get_baked_length()])
	
	var index: int
	var last_direction: Vector3
	for point in path:
		if not point.is_valid():
			continue
		
		if index == path.size() - 1:
			# Backwards from last direction to point in the direction of last tile before the end of path
			_setup_path_cell(point, path_ending_mesh, _get_path_ending_direction_rotation(-last_direction))
			break
		
		var next_point = path[index + 1]
		var direction = grid_generation.get_direction_from_to_cell(point, next_point)
		var rotation = Vector3.ZERO
		var current_mesh = path_straight_mesh
		
		if index == 0:
			current_mesh = path_ending_mesh
			rotation = _get_path_ending_direction_rotation(direction)
		elif last_direction != direction:
			rotation = _get_path_corner_direction_rotation(last_direction, direction)
			current_mesh = path_corner_mesh
		else:
			rotation = _get_straight_path_direction_rotation(direction)
		
		_setup_path_cell(point, current_mesh, rotation)
		index += 1
		last_direction = direction
	

func _setup_path_cell(cell_handle : GridComponent.CellHandle, mesh : Mesh, rotation : Vector3) -> void:
	grid_generation.set_cell_mesh(cell_handle, mesh)
	grid_generation.set_cell_rotation(cell_handle, rotation)
	

func _get_straight_path_direction_rotation(direction : Vector3) -> Vector3:
	var rotation: Vector3 = Vector3.ZERO
	var vertical_product = direction.dot(Vector3.RIGHT)
	
	const VERTICAL_ROTATION = Vector3(0, 90, 0)
	
	# Path pointing up or down
	if vertical_product > 0 or vertical_product < 0:
		rotation = VERTICAL_ROTATION
	return rotation
	

func _get_path_ending_direction_rotation(direction : Vector3) -> Vector3:
	var facing_direction = _get_direction_as_enum(direction)
	var rotation: Vector3 = Vector3.ZERO
	
	const DOWN_ROTATION = Vector3(0, 0, 0)
	const RIGHT_ROTATION = Vector3(0, 90, 0)
	const UP_ROTATION = Vector3(0, 180, 0)
	const LEFT_ROTATION = Vector3(0, 270, 0)
	
	match facing_direction:
		FacingDirection.Down:
			rotation = DOWN_ROTATION
		
		FacingDirection.Right:
			rotation = RIGHT_ROTATION
		
		FacingDirection.Up:
			rotation = UP_ROTATION
		
		FacingDirection.Left:
			rotation = LEFT_ROTATION
	
	return rotation
	

func _get_path_corner_direction_rotation(last_direction : Vector3, direction : Vector3) -> Vector3:
	var last_facing_direction = _get_direction_as_enum(last_direction)
	var facing_direction = _get_direction_as_enum(direction)
	var rotation: Vector3 = Vector3.ZERO
	
	# For visualization of name: Draw shape following direction, corner of shape points
	const POINT_TOP_LEFT_ROTATION = Vector3(0, 0, 0)
	const POINT_TOP_RIGHT_ROTATION = Vector3(0, 90, 0)
	const POINT_BOTTOM_RIGHT_ROTATION = Vector3(0, 180, 0)
	const POINT_BOTTOM_LEFT_ROTATION = Vector3(0, 270, 0)
	
	match last_facing_direction:
		FacingDirection.Down:
			if facing_direction == FacingDirection.Right:
				rotation = POINT_BOTTOM_LEFT_ROTATION
			else:
				rotation = POINT_BOTTOM_RIGHT_ROTATION
			
		
		FacingDirection.Right:
			if facing_direction == FacingDirection.Up:
				rotation = POINT_BOTTOM_RIGHT_ROTATION
			else:
				rotation = POINT_BOTTOM_LEFT_ROTATION
			
		
		FacingDirection.Up:
			if facing_direction == FacingDirection.Right:
				rotation = POINT_TOP_LEFT_ROTATION
			else:
				rotation = POINT_BOTTOM_LEFT_ROTATION
			
		
		FacingDirection.Left:
			if facing_direction == FacingDirection.Up:
				rotation = POINT_TOP_RIGHT_ROTATION
			else:
				rotation = POINT_TOP_LEFT_ROTATION
			
	
	return rotation
	

func _get_direction_as_enum(direction : Vector3) -> FacingDirection:
	var horizontal_product = direction.dot(Vector3.RIGHT)
	var facing_direction: FacingDirection = FacingDirection.Right
	
	if horizontal_product > 0 or horizontal_product < 0:
		if horizontal_product < 0:
			facing_direction = FacingDirection.Left
	else:
		var vertical_product = direction.dot(Vector3.FORWARD)
		if vertical_product < 0:
			facing_direction = FacingDirection.Down
		else:
			facing_direction = FacingDirection.Up
		
	
	return facing_direction
