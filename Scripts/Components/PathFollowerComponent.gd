class_name PathFollowerComponent
extends Node

@export_category("Node To Move")
@export var target: Node3D

@export_category("Configuration")
@export var speed: float

var distance_traveled: float

func update_distance_traveled(path_handler : EnemyPathComponent, delta : float):
	distance_traveled += speed * delta
	var path_data: EnemyPathComponent.PathTravelData = path_handler.get_position_data_along_path(distance_traveled)
	target.global_position = path_data.position
	
