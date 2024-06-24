class_name EnemyWavesData
extends Resource

signal enemy_spawned(enemy : Enemy)
signal updated_time_rate(reduce_time : float)

@export_category("Waves Configuration")
@export var _waves: Array[WaveSpawnData]

var spawn_position: Vector3 = Vector3.ZERO
var _current_wave: int = 0
var _parent: Node

func is_valid() -> bool:
	return _waves and not _waves.is_empty()
	

func start_wave_spawning_at(position : Vector3, parent_to : Node) -> void:
	if not GenerationUtils.is_parent_valid(parent_to):
		assert(false, "Parent must be inside tree and not null, otherwise instances wont be visible")
		return
	
	if _waves.is_empty() or _current_wave >= _waves.size():
		assert(false, "No waves set")
		return
	
	spawn_position = position
	_parent = parent_to
	var first_wave: WaveSpawnData = _waves[_current_wave]
	
	for enemy_spawn_data in first_wave._enemies_spawn_data:
		if not enemy_spawn_data or not enemy_spawn_data.is_valid():
			printerr("Enemy data has invalid scene")
			continue
		
		enemy_spawn_data.setup_spawn_rate()
		var tree_delay_timer = _parent.get_tree().create_timer(enemy_spawn_data.get_spawn_delay())
		tree_delay_timer.timeout.connect(_start_enemy_spawn_rate.bind(enemy_spawn_data))
		
	

func _start_enemy_spawn_rate(enemy_data : EnemySpawnData) -> void:
	enemy_data.spawn_rate_reached.connect(_spawn_enemy.bind(enemy_data))
	enemy_data.enemy_count_reached.connect(_disconnect_spawn_rate_update_listener.bind(enemy_data))
	_connect_spawn_rate_update_listener(enemy_data)
	
	if enemy_data._is_first_spawn_instant:
		_spawn_enemy(enemy_data)
	

func _connect_spawn_rate_update_listener(enemy_data : EnemySpawnData) -> void:
	updated_time_rate.connect(enemy_data.update_spawn_rate.bind())
	

func _disconnect_spawn_rate_update_listener(enemy_data : EnemySpawnData) -> void:
	updated_time_rate.disconnect(enemy_data.update_spawn_rate.bind())
	

func reduce_spawn_rate_timer_by(value : float) -> void:
	updated_time_rate.emit(value)
	

func _spawn_enemy(enemy_data : EnemySpawnData) -> void:
	enemy_spawned.emit(enemy_data.spawn_enemy_at(spawn_position, _parent))
	
