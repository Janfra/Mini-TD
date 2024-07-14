class_name PlaceableData
extends Resource

## Holds data related to placeable object

@export_category("Dependencies")
@export var placeable_scene: PackedScene

var debug_counter: int = 0

func is_valid() -> bool:
	return placeable_scene and placeable_scene.can_instantiate()
	

func instantiate_placeable_to(parent_node : Node) -> Node:
	if not is_valid():
		assert(false, "Using invalid placeable, setup it up or remove it")
		return null
		
	
	var instance: Node = placeable_scene.instantiate();
	
	var name = GenerationUtils.get_trimmed_file_name(placeable_scene)
	debug_counter += 1
	name += " #%s" %debug_counter
	GenerationUtils.setup_node_parent(instance, name, parent_node)
	
	return instance

func _to_string() -> String:
	return GenerationUtils.get_trimmed_file_name(self)
	
