@tool
class_name GridGenerator
extends Node3D

## Creates a grid with the configuration

@export_category("Generation Configuration")
@export var base_block: PackedScene
@export var grid_width: int = 1: set = _set_width
@export var grid_length: int = 1: set = _set_lenght
@export var x_offset:float = 0.0
@export var z_offset:float = 0.0

var _generated_cells: Dictionary 

class CellHandle:
	var _index: int = -1
	
	func _init(set_index : int):
		if set_index < 0:
			return
		
		_index = set_index
	
	func is_valid() -> bool:
		return not (_index < 0)
		
	

func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray
	if not base_block:
		warning.append("Need to set a base block for generation ")
	
	return warning
	

#region Public Methods
#region Generation
func generate_grid(_start : bool = false) -> void:
	if not base_block:
		printerr("Set base block before generating")
		return
	
	print("Generating grid")
	if not _generated_cells:
		_generated_cells = {}
	
	var index: int = 0
	for y in grid_length:
		for x in grid_width:
			_generate_cell(index, Vector2(x, y))
			index += 1
			
			print("Generate cell at index: %s" % index)
	

func clear_grid(_clear : bool) -> void:
	for cell in _generated_cells.values():
		var node = cell as Node3D
		node.queue_free()
	
	_generated_cells.clear()
	
#endregion

#region Getters
func get_random_opposing_border_cells() -> Array[CellHandle]:
	var opposing_cells: Array[CellHandle]
	
	var rng = RandomNumberGenerator.new()
	var is_horizontal : bool = rng.randi_range(0, 1)
	var cell_index: int
	
	if is_horizontal:
		cell_index = _get_random_left_border_cell_index(rng)
		opposing_cells.append(CellHandle.new(cell_index))
		
		cell_index = _get_random_right_border_cell_index(rng)
		opposing_cells.append(CellHandle.new(cell_index))
		
	else:
		cell_index = _get_random_top_border_cell_index(rng)
		opposing_cells.append(CellHandle.new(cell_index))
		
		cell_index = _get_random_bottom_border_cell_index(rng)
		opposing_cells.append(CellHandle.new(cell_index))
		
	
	opposing_cells.shuffle()
	return opposing_cells

func get_cell_position(cell_handle : CellHandle) -> Vector3:
	return _get_holder_with_handle(cell_handle).global_position
	

# TEST: Temporary for testing
func get_cell_mesh(cell_handle : CellHandle) -> MeshInstance3D:
	return _get_holder_with_handle(cell_handle)._mesh
	

func get_cell_path_from_to():
	pass

#endregion
#endregion

#region Private Methods
#region Generation
func _set_width(width_size : int) -> void:
	grid_width = max(width_size, 1)
	

func _set_lenght(length_size : int) -> void:
	grid_length = max(length_size, 1)
	

func _get_block_position(generation_position : Vector2, node : Node) -> Vector3:
	if not (node is HolderComponent):
		assert(false, "Base block Node must be a holder component")
		return Vector3()
	
	var holder = node as HolderComponent
	if not holder:
		assert(false, "Why are we here")
		return Vector3()
	
	var block_position_offset: Vector3 = Vector3.ZERO
	var block_bounds: Vector3 = holder.get_mesh_bounds()
	var x_offset_multiplier: int = min(generation_position.x, 1)
	var z_offset_multiplier: int = min(generation_position.y, 1)
	
	block_position_offset.x = (generation_position.x * block_bounds.x + generation_position.x * x_offset) * x_offset_multiplier
	block_position_offset.z = (generation_position.y * block_bounds.z + generation_position.y * z_offset) * z_offset_multiplier
	
	var centering_offset: Vector3 = Vector3.ZERO
	# Remove half a block since it is generated with corner on origin
	centering_offset.x = (block_bounds.x * (grid_width - 1)) / 2 
	centering_offset.z = (block_bounds.z * (grid_length - 1)) / 2
	
	return block_position_offset + (global_position - centering_offset)
	

func _generate_cell(index : int, generation_position : Vector2) -> void:
	if _generated_cells.has(index):
		print("Already have index")
		return
	
	if not base_block.can_instantiate():
		assert(false, "Base block is not instanteable")
		return
	
	var block_instance:Node = base_block.instantiate()
	GenerationUtils.setup_node_parent(block_instance, "Base Block #%s" % index, self) 
	_generated_cells[index] = block_instance
	block_instance.global_position = _get_block_position(generation_position, block_instance)
#endregion

func _get_holder_with_handle(cell_handle : CellHandle) -> HolderComponent:
	if not _generated_cells.has(cell_handle._index):
		printerr("Tried to fetch with invalid index: %s" %cell_handle._index)
		return null
	
	return _generated_cells[cell_handle._index]

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

