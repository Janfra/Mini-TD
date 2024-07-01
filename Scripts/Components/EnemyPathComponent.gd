class_name EnemyPathComponent
extends Path3D

signal updated_movement(path_handler : EnemyPathComponent, delta : float)

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
		

func add_path_follower_listener(follower : PathFollowerComponent) -> void:
	if not follower:
		printerr("Trying to add a null path follower")
		return
	
	updated_movement.connect(follower.update_distance_traveled.bind())
	

func remove_path_follower_listener(follower : PathFollowerComponent) -> void:
	if not follower:
		printerr("Trying to add a null path follower")
		return
	
	updated_movement.disconnect(follower.update_distance_traveled.bind())
	

func update_path_followers_location(delta : float) -> void:
	updated_movement.emit(self, delta)
	

func update_display_path_hint(delta : float) -> void:
	path_follow.progress = display
	display += delta * display_speed
	

func add_to_path_given_locations(grid : Array[Vector3]) -> void:
	for point in grid:
		curve.add_point(point)
		print(point)
		
	

func get_position_data_along_path(distance_travelled : float) -> PathTravelData:
	assert(path_follow, "There is no path assigned to handle following")
	
	var is_path_completed: bool = false
	if distance_travelled >= curve.get_baked_length():
		distance_travelled = curve.get_baked_length()
		is_path_completed = true
	
	return PathTravelData.new(_get_distance_position_on_path(distance_travelled), is_path_completed)
	

func get_beginning_of_path_position() -> Vector3:
	return _get_distance_position_on_path(0.0)
	

func _get_distance_position_on_path(distance_travelled : float) -> Vector3:
	path_follow.progress = distance_travelled
	return path_follow.global_position
	
