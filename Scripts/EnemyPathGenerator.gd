class_name EnemyPathGenerator
extends Path3D

func add_to_path_given_locations(grid : Array[Vector3]) -> void:
	for point in grid:
		curve.add_point(point)
		
	
