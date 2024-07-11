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

func deal_damage(damage : int) -> void:
	health -= damage
	damaged.emit()
	
	_check_for_health_depleted()
	

func heal(heal_amount : int) -> void:
	health += heal_amount
	healed.emit()
	

func _check_for_health_depleted() -> void:
	if is_health_depleted:
		health_depleted.emit()
	
