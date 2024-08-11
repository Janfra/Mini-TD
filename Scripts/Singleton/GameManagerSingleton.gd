extends Node

signal game_state_changed(state : GameStates)
signal lost_game

enum GameStates
{
	Menu,
	Play,
	Pause,
	Lost,
}

var enemy_manager: EnemyManager
var current_state: GameStates = GameStates.Play

func get_enemy_manager() -> EnemyManager:
	return enemy_manager
	

func set_enemy_manager(manager : EnemyManager) -> void:
	if not is_instance_valid(manager):
		assert(false, "Don't set enemy manager to invalid reference")
		return
	
	assert(!enemy_manager, "Enemy manager is already set, it shouldn't be set twice")
	enemy_manager = manager
	

func try_update_game_state(new_state : GameStates) -> bool:
	if not _is_state_valid_transition(new_state):
		assert(false, "Shouldn't be trying to transition from current state to given state")
		return false
	
	current_state = new_state
	_handle_state_transition()
	
	return true


func _handle_state_transition() -> void:
	match(current_state):
		GameStates.Lost:
			lost_game.emit()
		GameStates.Play:
			## TEST: For now just reload scene
			get_tree().reload_current_scene()
	

func _is_state_valid_transition(state : GameStates) -> bool:
	if current_state == state:
		return false
	
	match(state):
		GameStates.Menu:
			return current_state == GameStates.Pause or current_state == GameStates.Lost
		GameStates.Play:
			return true
		GameStates.Pause, GameStates.Lost:
			return current_state == GameStates.Play
	
	return false
