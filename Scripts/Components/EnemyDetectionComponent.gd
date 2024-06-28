class_name EnemyDetectionComponent
extends Area3D

signal detected_enemy(enemy : Enemy)
signal enemy_left_range(enemy : Enemy)

@export_category("Depedencies")
@export var collision: CollisionShape3D

@export_category("Configuration")
@export var range: float = 1

func _ready() -> void:
	monitoring = true
	monitorable = false
	

func _on_area_entered(area : Area3D) -> void:
	var parent_node: Node = area.get_parent()
	if parent_node is Enemy:
		detected_enemy.emit(parent_node as Enemy)
	

func _on_area_exited(area : Area3D) -> void:
	var parent_node: Node = area.get_parent()
	if parent_node is Enemy:
		enemy_left_range.emit(parent_node as Enemy)
	
