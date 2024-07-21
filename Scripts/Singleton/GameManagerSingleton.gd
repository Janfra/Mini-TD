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

var current_state: GameStates = GameStates.Play

func try_update_game_state(new_state : GameStates) -> bool:
	if not _is_state_valid_transition(new_state):
		assert(false, "Shouldn't be trying to transition from current state to given state")
		return false
	
	current_state = new_state
	handle_state_transition()
	
	return true

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

func handle_state_transition() -> void:
	match(current_state):
		GameStates.Lost:
			lost_game.emit()
		GameStates.Play:
			## TEST: For now just reload scene
			get_tree().reload_current_scene()
	
