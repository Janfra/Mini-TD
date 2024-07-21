extends Control

func _on_button_pressed():
	print("Change to play")
	GameManager.try_update_game_state(GameManager.GameStates.Play)
	
