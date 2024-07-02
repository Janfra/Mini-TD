class_name NotifiedNode3D
extends Node3D

## Temporary: Will use this node to set lifetimes to give some sort of duration to execute any last logic before being freed. 
## Will probably be replaced once object pooling is added

signal freed

@export_category("Configuration")
@export var lifetime: float
@export var hide_on_free: Array[Node3D]

func set_off_lifetime() -> void:
	freed.emit()
	for hide in hide_on_free:
		hide.hide()
		
	
	await get_tree().create_timer(abs(lifetime), false).timeout
	queue_free()
	