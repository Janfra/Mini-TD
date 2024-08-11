class_name EnemyManager
extends Node

@export_category("Dependencies")
@export var path: PathComponent
@export var waves_data: EnemyWavesData

func _ready() -> void:
	GameManager.set_enemy_manager(self)
	await get_parent().ready
	_spawn_and_setup_wave_enemies()
	

func _process(delta):
	path.update_path_followers_location(delta)
	if waves_data:
		waves_data.reduce_spawn_rate_timer_by(delta)
	

func get_most_distance_travelled_enemy(enemies : Array[Enemy]) -> Enemy:
	if enemies.is_empty():
		return null
	
	var current_match: Enemy
	for enemy in enemies:
		if current_match:
			if enemy.path_follower.has_travelled_further_than(current_match.path_follower):
				current_match = enemy
		else:
			current_match = enemy
		
	
	return current_match

func get_least_distance_travelled_enemy(enemies : Array[Enemy]) -> Enemy:
	if enemies.is_empty():
		return null
	
	var current_match: Enemy
	for enemy in enemies:
		if current_match:
			if not enemy.path_follower.has_travelled_further_than(current_match.path_follower):
				current_match = enemy
		else:
			current_match = enemy
		
	
	return current_match
	

func _spawn_and_setup_wave_enemies() -> void:
	if not waves_data or not waves_data.is_valid():
		printerr("No waves setup")
		return
	
	# TEST: For testing that it follows path correctly
	waves_data.wave_spawn_started.connect(_wave_officially_started)
	var current_wave = waves_data.start_wave_spawning_at(path.get_beginning_of_path_position(), self)
	waves_data.enemy_spawned.connect(_setup_spawned_enemy.bind())
	UIEvents.wave_countdown_started.emit(current_wave._wave_start_delay)
	

func _setup_spawned_enemy(enemy : Enemy) -> void:
	path.add_path_follower_listener(enemy.path_follower)
	

func _wave_officially_started() -> void:
	GameEvents.wave_spawning_started.emit()
	
