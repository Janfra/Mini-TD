class_name HealthComponent
extends Node

signal health_depleted
signal healed
signal damaged

@export_category("Configuration")
@export var max_health: int = 1

@onready var health: int = max_health

var is_health_depleted: bool:
	get:
		return health <= 0

## Deal damage to health
func deal_damage(damage : int) -> void:
	health -= damage
	damaged.emit()
	
	_check_for_health_depleted()
	

## Check if value would deplete health
func is_damage_value_lethal(damage : int) -> bool:
	return (health - damage) <= 0
	

## Restore health by amount
func heal(heal_amount : int) -> void:
	health += heal_amount
	healed.emit()
	

## Emit signal if health is depleted
func _check_for_health_depleted() -> void:
	if is_health_depleted:
		health_depleted.emit()
	
