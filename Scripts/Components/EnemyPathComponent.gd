class_name EnemyPathComponent
extends Path3D

@export_category("Dependencies")
@export var path_follow: PathFollow3D

@export_category("Hint")
@export var display_speed: float 

var display: float 

class PathTravelData:
	var position: Vector3
	var is_path_completed: bool
	
	func _init(current_position : Vector3, is_completed : bool):
		position = current_position
		is_path_completed = is_completed
		

func add_to_path_given_locations(grid : Array[Vector3]) -> void:
	for point in grid:
		curve.add_point(point)
		
	

func _process(delta):
	# Display path 
	path_follow.progress = display
	display += delta * display_speed
	

func get_position_data_along_path(distance_travelled : float) -> PathTravelData:
	assert(path_follow, "There is no path assigned to handle following")
	
	var is_path_completed: bool = false
	if distance_travelled >= curve.get_baked_length():
		distance_travelled = curve.get_baked_length()
		is_path_completed = true
	
	path_follow.progress = distance_travelled
	return PathTravelData.new(path_follow.global_position, is_path_completed)
	
