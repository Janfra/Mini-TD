@tool
class_name GridGenerator
extends Node3D

## Creates a grid with the configuration

@export_category("Generation Configuration")
@export var base_block: Mesh
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
	
	var block_instance:MeshInstance3D = MeshInstance3D.new()
	add_child(block_instance)
	block_instance.owner = self
	generated_cells[index] = block_instance
	
	block_instance.mesh = base_block
	block_instance.global_position = get_block_position(generation_position)
	block_instance.name = "Base Block #%s" % index
	

func get_block_position(generation_position : Vector2) -> Vector3:
	var mesh_bounds:AABB = base_block.get_aabb()
	if not mesh_bounds:
		printerr("Mesh bounds not found")
		return Vector3()
	
	
	var block_position_offset: Vector3
	var mesh_size: Vector3 = mesh_bounds.size
	var x_offset_multiplier: int = min(generation_position.x, 1)
	var z_offset_multiplier: int = min(generation_position.y, 1)
	
	block_position_offset.x = (generation_position.x * mesh_size.x + generation_position.x * x_offset) * x_offset_multiplier
	block_position_offset.z = (generation_position.y * mesh_size.z + generation_position.y * z_offset) * z_offset_multiplier
	
	var centering_offset: Vector3
	centering_offset.x = (mesh_size.x * grid_width) / 2 
	# Remove 1 full block lenght since first block is generated on left side of origin
	centering_offset.z = (mesh_size.z * (grid_length - 2)) / 2
	
	return block_position_offset + (global_position - centering_offset)
	

func clear_grid(_clear : bool) -> void:
	for cell in generated_cells.values():
		var node = cell as Node3D
		node.queue_free()
	
	generated_cells.clear()
