class_name HealthComponent
extends Node

signal health_depleted
signal healed
signal damaged

@export_category("Configuration")
@export var max_health: int = 1

@onready var health: int = max_health

func deal_damage(damage : int) -> void:
	health -= damage
	damaged.emit()
	
	_is_out_of_health()
	

func heal(heal_amount : int) -> void:
	health += heal_amount
	healed.emit()
	

func _is_out_of_health() -> bool:
	var is_health_depleted: bool = health <= 0
	if is_health_depleted:
		health_depleted.emit()
		
	
	return is_health_depleted
