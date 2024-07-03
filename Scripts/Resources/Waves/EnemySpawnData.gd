class_name EnemySpawnData
extends Resource

static var name_index: int = 0

signal spawn_rate_reached
signal enemy_count_reached

@export_category("Enemy Spawning Configuration")
@export var _enemy_definition: EnemyDefinitionData
@export var _is_first_spawn_instant: bool
@export var _enemy_count: int
@export var _spawn_rate: float
@export var _spawn_delay: float

var _current_rate: float = 0.0
var _current_count: int = 0

# Don't like hard-coded path, but will do for now
static var _enemy_scene: PackedScene = preload("res://Assets/Gameplay_Scenes/enemy_test.tscn")

func is_valid() -> bool:
	assert(_enemy_scene, "Enemy Scene Not Found")
	return _enemy_scene and _enemy_scene.can_instantiate()
	

func can_spawn() -> bool:
	return _enemy_count > 0 and _enemy_count > _current_count
	

func spawn_enemy_at(position : Vector3, parent_to : Node) -> Enemy:
	var spawned: Enemy = _enemy_scene.instantiate()
	if not spawned:
		assert(false, "Non enemy set for enemy wave")
		return spawned
	
	GenerationUtils.setup_node_parent(spawned, "Test Enemy #%s" % name_index, parent_to)
	spawned.global_position = position
	spawned.setup_enemy(_enemy_definition)
	_increase_spawned_count()
	
	name_index += 1
	
	return spawned
	

func get_spawn_delay() -> float:
	return _spawn_delay
	

func setup_spawn_rate() -> void:
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
	
