class_name WaveSpawnData
extends Resource

@export_category("Per Wave Configuration")
@export var _enemies_spawn_data: Array[EnemySpawnData]
@export var _wave_start_delay: float

func _init():
	_enemies_spawn_data.append(EnemySpawnData.new())
	

