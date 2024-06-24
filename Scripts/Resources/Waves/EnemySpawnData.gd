class_name EnemySpawnData
extends Resource

signal spawn_rate_reached
signal enemy_count_reached

@export_category("Enemy Spawning Configuration")
@export var _enemy_scene: PackedScene
@export var _is_first_spawn_instant: bool
@export var _enemy_count: int
@export var _spawn_rate: float
@export var _spawn_delay: float

var _current_rate: float = 0.0
var _current_count: int = 0

func is_valid() -> bool:
	return _enemy_scene and _enemy_scene.can_instantiate()
	

func spawn_enemy_at(position : Vector3, parent_to : Node) -> Enemy:
	var spawned: Enemy = _enemy_scene.instantiate()
	if not spawned:
		assert(false, "Non enemy set for enemy wave")
		return spawned
	
	GenerationUtils.setup_node_parent(spawned, "Test Enemy", parent_to)
	spawned.global_position = position
	_increase_spawned_count()
	
	return spawned
	

func get_spawn_delay() -> float:
	return _spawn_delay
	

func setup_spawn_rate():
	_current_rate = _spawn_rate
	

func update_spawn_rate(reduce_time : float) -> void:
	_current_rate -= reduce_time
	if _current_rate <= 0.0:
		spawn_rate_reached.emit()
		setup_spawn_rate()
		
	

func _increase_spawned_count() -> void:
	_current_count += 1
	if _current_count >= _enemy_count:
		enemy_count_reached.emit()
		_current_count = 0
	
