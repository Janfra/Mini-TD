@tool
class_name GridComponent
extends Node3D

## Creates a grid with the configuration

signal grid_cells_changed

@export_category("Generation Configuration")
@export var base_block: PackedScene
@export var grid_width: int = 1: set = _set_width
@export var grid_length: int = 1: set = _set_lenght
@export var x_offset:float = 0.0
@export var z_offset:float = 0.0

@export_category("Debugging")
@export var _generate_debug_grid:bool: 
	set(value):
		if Engine.is_editor_hint():
			generate_grid()
@export var _clear_debug_grid:bool:
	set(value):
		if Engine.is_editor_hint():
			clear_grid()

var _generated_cells: Dictionary 
var has_generated: bool: 
	get:
		return _generated_cells and not _generated_cells.is_empty()

class CellHandle:
	## Handles give access to information from a cell in a grid.
	## They become invalid if the grid is changed for now
	
	const INVALID_INDEX: int = -1
	var _index: int = INVALID_INDEX
	
	func _init(set_index : int, invalidate_on_signal : Signal = Signal()):
		if set_index < 0:
			return
		
		_index = set_index
		if not invalidate_on_signal.is_null():
			invalidate_on_signal.connect(invalidate_handle.bind())
		
	
	func is_valid() -> bool:
		return not (_index < 0)
		
	
	func invalidate_handle() -> void:
		_index = INVALID_INDEX
	

class CellData:
	var holder: HolderComponent
	var width_position: int
	var lenght_position: int
	
	func _init(set_holder : HolderComponent, set_grid_position : Vector2):
		holder = set_holder
		width_position = set_grid_position.x
		lenght_position = set_grid_position.y
		
	

func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray
	if not base_block:
		warning.append("Need to set a base block for generation ")
	
	return warning
	

#region Public Methods
#region Generation
func generate_grid() -> void:
	if not base_block:
		printerr("Set base block before generating")
		return
	
	print("Generating grid")
	if not _generated_cells:
		_generated_cells = {}
	
	grid_cells_changed.emit()
	
	var index: int = 0
	for y in grid_length:
		for x in grid_width:
			_generate_cell(index, Vector2(x, y))
			print("Generate cell at index: %s" % index)
			index += 1
			
	

func clear_grid() -> void:
	for cell in _generated_cells.values():
		var data:CellData = cell as CellData
		data.holder.queue_free()
	
	grid_cells_changed.emit()
	_generated_cells.clear()
	
#endregion

#region Getters
func get_path_from_to_cell(path_start : CellHandle, path_end : CellHandle) -> Array[CellHandle]:
	var path: Array[CellHandle]
	var distance: int = abs(path_start._index - path_end._index)
	if distance == 0:
		return path
	print("Start: %s - End: %s - Distance: %s" % [path_start._index, path_end._index, distance])
	
	var start_data: CellData = _get_cell_data_with_handle(path_start)
	var end_data: CellData = _get_cell_data_with_handle(path_end)
	
	var vector_start = Vector2i(start_data.width_position, start_data.lenght_position)
	var vector_end = Vector2i(end_data.width_position, end_data.lenght_position)
	print("Start: %s - End: %s" % [vector_start, vector_end])
	
	# Get steps required in index and their direction with multiplier
	var result_vector =  vector_end - vector_start
	var multiplier_vector = result_vector.sign()
	print("Total steps: %s" % [result_vector])
	
	# Add start
	var current_index: int = path_start._index
	path.append(_create_cell_handle(current_index))
	
	# Add each step until end
	for x in abs(result_vector.x):
		current_index += 1 * multiplier_vector.x
		path.append(_create_cell_handle(current_index))
	
	for y in abs(result_vector.y):
		current_index += _convert_lenght_to_index(1) * multiplier_vector.y
		path.append(_create_cell_handle(current_index))
	
	return path

func get_random_opposing_border_cells() -> Array[CellHandle]:
	var opposing_cells: Array[CellHandle]
	
	var rng = RandomNumberGenerator.new()
	var is_horizontal : bool = rng.randi_range(0, 1)
	var cell_index: int
	
	if is_horizontal:
		cell_index = _get_random_left_border_cell_index(rng)
		opposing_cells.append(_create_cell_handle(cell_index))
		
		cell_index = _get_random_right_border_cell_index(rng)
		opposing_cells.append(_create_cell_handle(cell_index))
		
	else:
		cell_index = _get_random_top_border_cell_index(rng)
		opposing_cells.append(_create_cell_handle(cell_index))
		
		cell_index = _get_random_bottom_border_cell_index(rng)
		opposing_cells.append(_create_cell_handle(cell_index))
		
	
	opposing_cells.shuffle()
	return opposing_cells

func get_cell_position(cell_handle : CellHandle) -> Vector3:
	if not cell_handle.is_valid():
		assert(false, "Tried fetchin with invalid handle")
		return Vector3.ZERO
	
	return _get_cell_data_with_handle(cell_handle).holder.global_position
	

func get_cells_positions(cell_handles : Array[CellHandle]) -> Array[Vector3]:
	var positions: Array[Vector3]
	for cell_handle in cell_handles:
		positions.append(get_cell_position(cell_handle))
	
	return positions

func get_direction_from_to_cell(from : CellHandle, to : CellHandle, normalised : bool = true) -> Vector3:
	var result: Vector3 = get_cell_position(to) - get_cell_position(from)
	if normalised:
		result = result.normalized()
	
	return result

#endregion

#region Setters
func set_cell_mesh(cell_handle : CellHandle, set_mesh : Mesh) -> void:
	_get_cell_data_with_handle(cell_handle).holder._mesh.mesh = set_mesh
	

func set_cell_rotation(cell_handle : CellHandle, rotation : Vector3) -> void:
	_get_cell_data_with_handle(cell_handle).holder.rotation_degrees = rotation
	

#endregion
#endregion

#region Private Methods
#region Generation
func _set_width(width_size : int) -> void:
	grid_width = max(width_size, 1)
	

func _set_lenght(length_size : int) -> void:
	grid_length = max(length_size, 1)
	

func _get_block_position(grid_position : Vector2, node : Node) -> Vector3:
	if not (node is HolderComponent):
		assert(false, "Base block Node must be a holder component")
		return Vector3()
	
	var holder = node as HolderComponent
	if not holder:
		assert(false, "Why are we here")
		return Vector3()
	
	var block_position_offset: Vector3 = Vector3.ZERO
	var block_bounds: Vector3 = holder.get_mesh_bounds()
	var x_offset_multiplier: int = min(grid_position.x, 1)
	var z_offset_multiplier: int = min(grid_position.y, 1)
	
	block_position_offset.x = (grid_position.x * block_bounds.x + grid_position.x * x_offset) * x_offset_multiplier
	block_position_offset.z = (grid_position.y * block_bounds.z + grid_position.y * z_offset) * z_offset_multiplier
	
	var centering_offset: Vector3 = Vector3.ZERO
	# Remove half a block since it is generated with corner on origin
	centering_offset.x = (block_bounds.x * (grid_width - 1)) * 0.5
	centering_offset.z = (block_bounds.z * (grid_length - 1)) * 0.5
	
	return block_position_offset + (global_position - centering_offset)
	

func _generate_cell(index : int, grid_position : Vector2) -> void:
	if _generated_cells.has(index):
		print("Already have index")
		return
	
	if not base_block.can_instantiate():
		assert(false, "Base block is not instanteable")
		return
	
	var block_instance:Node = base_block.instantiate()
	GenerationUtils.setup_node_parent(block_instance, "Base Block #%s" % index, self) 
	block_instance.global_position = _get_block_position(grid_position, block_instance)
	_register_cell(index, block_instance, grid_position)

func _register_cell(index : int, holder : HolderComponent, grid_position : Vector2) -> void:
	_generated_cells[index] = CellData.new(holder, grid_position)
	

#endregion

func _get_cell_data_with_handle(cell_handle : CellHandle) -> CellData:
	if not _generated_cells.has(cell_handle._index):
		assert(false, "Tried to fetch with invalid index: %s" %cell_handle._index)
		return null
	
	return _generated_cells[cell_handle._index]

func _create_cell_handle(index : int) -> CellHandle:
	if not _generated_cells.has(index):
		return CellHandle.new(CellHandle.INVALID_INDEX)
	
	return CellHandle.new(index, grid_cells_changed)
	

func _convert_lenght_to_index(length_value : int) -> int:
	return length_value * grid_width

#region Get Random Cell
func _get_random_top_border_cell_index(rng : RandomNumberGenerator = RandomNumberGenerator.new()) -> int:
	var random_index = rng.randi_range(0, grid_width - 1)
	return random_index

func _get_random_bottom_border_cell_index(rng : RandomNumberGenerator = RandomNumberGenerator.new()) -> int:
	var index_start = grid_width * (grid_length - 1)
	var random_index = rng.randi_range(index_start, index_start + (grid_width - 1))
	return random_index

func _get_random_left_border_cell_index(rng : RandomNumberGenerator = RandomNumberGenerator.new()) -> int:
	var random_index = rng.randi_range(0, grid_length - 1)
	random_index *= grid_width
	return random_index

func _get_random_right_border_cell_index(rng : RandomNumberGenerator = RandomNumberGenerator.new()) -> int:
	var random_index = rng.randi_range(0, grid_length - 1)
	random_index += (grid_width - 1) * (random_index + 1)
	return random_index
#endregion
#endregion

