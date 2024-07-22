class_name LifetimeNode3D
extends Node3D

## Temporary: Will use this node to set lifetimes to give some sort of duration to execute any last logic before being freed. 
## Will probably be replaced or adjusted once object pooling is added

signal freed

@export_category("Configuration")
@export var lifetime: float = 0.1: set = set_lifetime
@export var hide_on_free: Array[Node3D]
@export var optional_parent: Node

func end_of_lifetime() -> void:
	freed.emit()
	for object_to_hide in hide_on_free:
		object_to_hide.hide()
		
	
	await get_tree().create_timer(abs(lifetime), false).timeout
	
	if is_instance_valid(optional_parent):
		optional_parent.queue_free()
		
	else:
		queue_free()
		
	

func set_lifetime(set_lifetime : float) -> void:
	lifetime = set_lifetime
	
