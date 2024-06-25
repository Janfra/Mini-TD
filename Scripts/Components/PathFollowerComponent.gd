class_name PathFollowerComponent
extends Node

@export_category("Node To Move")
@export var target: Node3D

@export_category("Configuration")
@export var speed: float

var _distance_traveled: float

func update_distance_traveled(path_handler : EnemyPathComponent, delta : float):
	_distance_traveled += speed * delta
	var path_data: EnemyPathComponent.PathTravelData = path_handler.get_position_data_along_path(_distance_traveled)
	target.global_position = path_data.position
	
	if path_data.is_path_completed:
		print("Completed path")
		path_handler.remove_path_follower_listener(self)
	
