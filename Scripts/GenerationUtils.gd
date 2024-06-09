class_name GenerationUtils
extends RefCounted

## Holds static functions that are commonly used across separate classes that require generation

static func setup_node_parent(node : Node, node_name : String, parent_node : Node) -> bool:
	if not parent_node:
		assert(false, "No valid parent node defined")
		return false
		
	
	node.name = node_name
	parent_node.add_child(node, false)
	var owner: Node = parent_node
	if parent_node.is_inside_tree():
		owner = parent_node.get_tree().edited_scene_root
	
	node.owner = owner
	return true
	
