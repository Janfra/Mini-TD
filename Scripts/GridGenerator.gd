@tool
class_name GridGenerator
extends Node3D

## Creates a grid with the configuration

@export_category("Generation Configuration")
@export var base_block: PackedScene
@export var grid_width: int = 1: set = set_width
@export var grid_length: int = 1: set = set_lenght
@export var x_offset:float = 0.0
@export var z_offset:float = 0.0

@export_category("Generate")
@export var start_generation: bool = 0: set = generate_grid
@export var clear_generation: bool = 0: set = clear_grid
@export var check_generation: bool = 0: 
	set(value):
		print(generated_cells)
		

var generated_cells: Dictionary 

func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray
	if not base_block:
		warning.append("Need to set a base block for generation ")
	
	return warning
	

func set_width(width_size : int) -> void:
	grid_width = max(width_size, 1)
	

func set_lenght(length_size : int) -> void:
	grid_length = max(length_size, 1)
	

func save_grid(_save : bool) -> void:
	pass

func generate_grid(_start : bool) -> void:
	if start_generation:
		printerr("Already generating")
		return
	
	if not base_block:
		printerr("Set base block before generating")
		return
	
	print("Generating grid")
	start_generation = true
	if not generated_cells:
		generated_cells = {}
	
	var index: int = 0
	for x in grid_width:
		for y in grid_length:
			generate_cell(index, Vector2(x, y))
			index += 1
			
			print("Generate cell at index: %s" % index)
	
	start_generation = false
	

func generate_cell(index : int, generation_position : Vector2) -> void:
	if generated_cells.has(index):
		print("Already have index")
		return
	
	var block_instance:Node = base_block.instantiate()
	GenerationUtils.setup_node_parent(block_instance, "Base Block #%s" % index, self) 
	generated_cells[index] = block_instance
	block_instance.global_position = get_block_position(generation_position, block_instance)
	

func get_block_position(generation_position : Vector2, node : Node) -> Vector3:
	if not (node is HolderComponent):
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
	

func clear_grid(_clear : bool) -> void:
	for cell in generated_cells.values():
		var node = cell as Node3D
		node.queue_free()
	
	generated_cells.clear()
	
