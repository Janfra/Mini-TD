class_name GameUI
extends Control

@export_category("Dependencies")
@export var money_label: Label
@export var health_label: Label

func _ready():
	Economy.money_changed.connect(set_money_label.bind())
	UIEvents.player_health_updated.connect(set_health_label.bind())
	GameEvents.lost_game.connect(display_lost_screen.bind())
	

func set_money_label(value : int) -> void:
	money_label.text = "Money: %s" % value
	

func set_health_label(value : int) -> void:
	health_label.text = "Health: %s" % value
	

func display_lost_screen() -> void:
	print("Display lost screen")
	
