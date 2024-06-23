class_name EnemyManager
extends Node

signal update_movement(path_handler : EnemyPathComponent, delta : float)

@export_category("Dependencies")
@export var path: EnemyPathComponent
@export var waves_data: EnemyWavesData

func _ready() -> void:
	await get_parent().ready
	
	if not waves_data or not waves_data.waves or waves_data.waves.is_empty() or not path:
		return
	
	# TEST: For testing that it follows path correctly
	var current_wave: EnemySpawnData = waves_data.waves.front()
	var enemies: Array[Enemy] = current_wave.spawn_enemies_at(path.get_position_data_along_path(0.0).position, self)
	for enemy in enemies:
		update_movement.connect(enemy.path_follower.update_distance_traveled.bind())
		
	

func _process(delta):
	update_movement.emit(path, delta)
	
