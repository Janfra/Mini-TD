class_name GenerationUtils
extends RefCounted

## Holds static functions that are commonly used across separate classes that require generation

static func setup_node_parent(node : Node, node_name : String, parent_node : Node) -> bool:
	if not is_parent_valid(parent_node):
		assert(false, "No valid parent node defined")
		return false
		
	
	node.name = node_name
	parent_node.add_child(node, false)
	var owner: Node = parent_node
	if parent_node.is_inside_tree():
		owner = parent_node.get_tree().edited_scene_root
	
	node.owner = owner
	return true
	

static func is_parent_valid(parent_node : Node) -> bool:
	return parent_node and parent_node.is_inside_tree()
	

static func get_trimmed_file_name(object : Resource) -> String:
	return object.resource_path.get_file().trim_suffix(".tres")
	
