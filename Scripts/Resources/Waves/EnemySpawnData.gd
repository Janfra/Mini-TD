class_name EnemySpawnData
extends Resource

@export_category("Per Wave Configuration")
@export var spawn_data: Array[PerWaveData]

func _init():
	spawn_data.append(PerWaveData.new())
	

func spawn_enemies_at(position : Vector3, parent_to : Node) -> Array[Enemy]:
	var enemies: Array[Enemy]
	for data in spawn_data:
		if not data.enemy_scene.can_instantiate():
			printerr("Enemy data has invalid scene")
			continue
		
		# just spawn for now only hard-coded enemies
		for i in data.enemy_count:
			var spawned: Enemy = data.enemy_scene.instantiate()
			if not spawned:
				assert(false, "Non enemy set for enemy wave")
				continue 
			
			GenerationUtils.setup_node_parent(spawned, "Test Enemy #%s" %i, parent_to)
			spawned.global_position = position
			enemies.append(spawned)
			
	return enemies
	
