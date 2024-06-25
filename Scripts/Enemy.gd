class_name Enemy
extends Node3D

@export_category("Dependencies")
@export var path_follower: PathFollowerComponent
@export var _mesh_instance: MeshInstance3D

## TBD: Setup components based on resource data?
func setup_enemy(enemy_definition : EnemyDefinitionData) -> void:
	path_follower.target = self
	_set_mesh(enemy_definition.mesh)
	_set_speed(enemy_definition.movement_speed)
	

func _set_speed(set_speed : float) -> void:
	path_follower.speed = set_speed
	

func _set_mesh(set_mesh : Mesh) -> void:
	if not set_mesh or set_mesh.get_surface_count() <= 0:
		printerr("Tried to set invalid mesh on Enemy")
		return
	
	if not _mesh_instance:
		printerr("Mesh instance not set on Enemy")
		return
	
	_mesh_instance.mesh = set_mesh
	
	# Center mesh based on size since assets pivot points is on the corner
	var bounds = set_mesh.get_aabb().size * 0.5
	_mesh_instance.global_position.x -= bounds.x
	_mesh_instance.global_position.z += bounds.z
	
