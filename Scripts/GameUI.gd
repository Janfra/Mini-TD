class_name GameUI
extends Control

@export_category("Dependencies")
@export var money_label: Label

func _ready():
	Economy.money_changed.connect(set_money_label.bind())
	

func set_money_label(value : int) -> void:
	money_label.text = "Money: %s" % value
	
