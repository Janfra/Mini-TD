class_name CurrencyComponent
extends Node

signal value_changed
signal value_applied

@export_category("Configuration")
@export var value: int

func update_value(set_value : int) -> void:
	value = set_value
	value_changed.emit()
	

func add_money() -> void:
	Economy.add_money(value)
	value_applied.emit()
	

func reduce_money() -> void:
	Economy.remove_money(value)
	value_applied.emit()
	
