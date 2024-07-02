class_name Enemy
extends Node3D

@export_category("Dependencies")
@export var path_follower: PathFollowerComponent
@export var _mesh_instance: MeshInstance3D
@export var _health_component: HealthComponent

func setup_enemy(enemy_definition : EnemyDefinitionData) -> void:
	path_follower.target = self
	_set_mesh(enemy_definition.mesh)
	_set_speed(enemy_definition.movement_speed)
	connect_to_dead_event(_handle_death.bind())
	_health_component.health = enemy_definition.health
	

func disconnect_to_dead_event(callable : Callable) -> void:
	_health_component.health_depleted.disconnect(callable)
	

func connect_to_dead_event(callable : Callable) -> void:
	_health_component.health_depleted.connect(callable)
	

func deal_damage(damage : int) -> void:
	if _health_component.is_health_depleted:
		return
	_health_component.deal_damage(damage)
	

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
	

func _handle_death() -> void:
	queue_free()
	
