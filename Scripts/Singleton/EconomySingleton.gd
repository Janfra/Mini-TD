extends Node

signal money_changed(new_value : int)

## Handles the game economy

var money: int

func add_money(value : int) -> void:
	money += abs(value)
	money_changed.emit(money)
	

func remove_money(value : int) -> void:
	money = min(0, money - abs(value))
	money_changed.emit(money)
	

func has_required_amount_of_money(amount) -> bool:
	return money >= amount
	
