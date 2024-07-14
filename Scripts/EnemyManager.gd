class_name EnemyManager
extends Node

@export_category("Dependencies")
@export var path: EnemyPathComponent
@export var waves_data: EnemyWavesData

func _ready() -> void:
	await get_parent().ready
	_spawn_and_setup_wave_enemies()
	

func _process(delta):
	path.update_path_followers_location(delta)
	if waves_data:
		waves_data.reduce_spawn_rate_timer_by(delta)
	

func _spawn_and_setup_wave_enemies() -> void:
	if not waves_data or not waves_data.is_valid():
		printerr("No waves setup")
		return
	
	# TEST: For testing that it follows path correctly
	waves_data.start_wave_spawning_at(path.get_beginning_of_path_position(), self)
	waves_data.enemy_spawned.connect(setup_spawned_enemy.bind())
	

func setup_spawned_enemy(enemy : Enemy) -> void:
	path.add_path_follower_listener(enemy.path_follower)
	
