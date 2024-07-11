class_name UINotifier
extends Node

## Handles sending off UI notifications for separated scenes

signal player_health_updated(value : int)

func update_player_health(value : int) -> void:
	player_health_updated.emit(value)
	
