class_name Enemy
extends Node3D

@export_category("Dependencies")
@export var path_follower: PathFollowerComponent
@export var _mesh_instance: MeshInstance3D
@export var _health_component: HealthComponent
@export var _currency_component: CurrencyComponent
@export var _lifetime_component: LifetimeNode3D

func _ready():
	connect_to_dead_event(_handle_death.bind())
	

func setup_enemy(enemy_definition : EnemyDefinitionData) -> void:
	_setup_path_follower(enemy_definition.movement_speed)
	_setup_currency(enemy_definition.value)
	_setup_health(enemy_definition.health)
	_set_mesh(enemy_definition.mesh)
	

func disconnect_to_dead_event(callable : Callable) -> void:
	assert(_health_component)
	_health_component.health_depleted.disconnect(callable)
	

func connect_to_dead_event(callable : Callable) -> void:
	assert(_health_component)
	_health_component.health_depleted.connect(callable)
	

func is_damage_value_lethal(damage : int) -> void:
	return _health_component.is_damage_value_lethal(damage)
	

func deal_damage(damage : int) -> void:
	if _health_component.is_health_depleted:
		return
	
	_health_component.deal_damage(damage)
	

func _setup_path_follower(set_speed : float) -> void:
	if not path_follower:
		printerr("No path follower component set in enemy")
		return
	
	path_follower.set_path_follower(self)
	path_follower.speed = set_speed
	

func _setup_currency(set_value : int) -> void:
	if not _currency_component:
		printerr("No currency component set in enemy")
		return
	
	_currency_component.value = set_value
	

func _setup_health(set_health : int) -> void:
	if not _health_component:
		printerr("No health component set in enemy")
		return
	
	_health_component.health = set_health
	

func _set_mesh(set_mesh : Mesh) -> void:
	if not set_mesh or set_mesh.get_surface_count() <= 0:
		printerr("Tried to set invalid mesh on Enemy")
		return
	
	if not _mesh_instance:
		printerr("Mesh instance not set on Enemy")
		return
	
	_mesh_instance.mesh = set_mesh
	

func _handle_death() -> void:
	_currency_component.add_money()
	_lifetime_component.end_of_lifetime()
	
