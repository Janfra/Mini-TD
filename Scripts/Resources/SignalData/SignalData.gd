@tool
class_name SignalData
extends Resource

@export_category("Dependencies")
@export var signal_owner: NodePath
@export var signal_name: String

func is_valid(listener : Node) -> bool:
	var node = _get_signal_node_relative_to(listener)
	if not is_instance_valid(node):
		return false
	
	return node.has_signal(signal_name)
	

func get_warning_errors(listener : Node) -> String:
	var found_errors: String
	var node = _get_signal_node_relative_to(listener)
	if not is_instance_valid(node):
		found_errors = "- Signal Node is invalid"
		return found_errors
	
	if not node.has_signal(signal_name):
		found_errors = "- Signal name is invalid"
	
	return found_errors

func connect_to_signal(listener : Node, callback : Callable) -> void:
	var node = _get_signal_node_relative_to(listener)
	if not is_instance_valid(node):
		assert(false, "Signal node relative position is not correct")
		return
	
	if not node.has_signal(signal_name):
		assert(false, "Signal node is invalid, it does not have given signal")
		return
	
	node.connect(signal_name, callback)
	

func _get_signal_node_relative_to(listener : Node) -> Node:
	return listener.get_node(signal_owner)
	

