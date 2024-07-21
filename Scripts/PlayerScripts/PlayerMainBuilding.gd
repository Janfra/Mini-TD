class_name PlayerMainBuilding
extends Node3D

@export_category("Dependencies")
@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(health_component)
	health_component.health_depleted.connect(_player_died.bind())
	health_component.healed.connect(_update_ui_health.bind())
	health_component.damaged.connect(_update_ui_health.bind())
	UIEvents.update_player_health(health_component.health)
	

func setup_building_connections(path : EnemyPathComponent) -> void:
	path.completed_path.connect(_handle_entering_node.bind())
	

func _handle_entering_node(node : Node3D) -> void:
	if node is Enemy:
		# TEST: Just deal one damage for now
		_damage_building(1)
		
	

func _damage_building(value : int) -> void:
	health_component.deal_damage(value)
	

func _player_died() -> void:
	print("Lost Game")
	health_component.health_depleted.disconnect(_player_died.bind())
	GameManager.try_update_game_state(GameManager.GameStates.Lost)
	

func _update_ui_health() -> void:
	UIEvents.update_player_health(health_component.health)
	
