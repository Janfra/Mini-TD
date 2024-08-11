extends Node

## Handles sending off UI notifications for separated scenes

signal player_health_updated(value : int)

signal wave_countdown_started(time : float)

func update_player_health(value : int) -> void:
	player_health_updated.emit(value)
	
