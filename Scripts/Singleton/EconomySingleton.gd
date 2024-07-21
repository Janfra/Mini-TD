extends Node

signal money_changed(new_value : int)

## Handles the game economy

var _money: int

func add_money(value : int) -> void:
	_money += abs(value)
	money_changed.emit(_money)
	

func remove_money(value : int) -> void:
	_money = max(0, _money - abs(value))
	money_changed.emit(_money)
	

func has_required_amount_of_money(amount) -> bool:
	return _money >= amount
	
