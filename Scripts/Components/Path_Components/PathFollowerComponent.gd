class_name PathFollowerComponent
extends Node

@export_category("Configuration")
@export var _target: Node3D
@export var speed: float

var _distance_traveled: float

func is_valid() -> bool:
	return _target and is_instance_valid(_target)
	

func update_distance_traveled(path_handler : PathComponent, delta : float):
	_distance_traveled += speed * delta
	var path_data: PathComponent.PathTravelData = path_handler.get_position_data_along_path(_distance_traveled)
	_target.global_position = path_data.position
	
	if path_data.is_path_completed:
		print("Completed path")
		path_handler.notify_path_completed(self)
		path_handler.remove_path_follower_listener(self)
	

func set_path_follower(set_target : Node3D) -> void:
	if _target and not (_target == set_target):
		print("Changed path follower component target from %s to %s" % [_target.name, set_target.name])
		
	
	_target = set_target
	

func has_travelled_further_than(other_path_follower : PathFollowerComponent) -> bool:
	return _distance_traveled > other_path_follower._distance_traveled
	
