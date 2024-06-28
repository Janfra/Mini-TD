class_name Tower
extends Node3D

@export_category("Dependencies")
@export var enemy_detection: EnemyDetectionComponent
@export var attack_component: AttackComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_detection.detected_enemy.connect(_attack_enemy.bind())
	enemy_detection.enemy_left_range.connect(_stop_attacking_enemy.bind())
	

func _attack_enemy(enemy : Enemy) -> void:
	print("pew pew")
	attack_component.add_attacking_target(enemy)
	

func _stop_attacking_enemy(enemy : Enemy) -> void:
	print("left")
	attack_component.remove_attacking_target(enemy)
	
