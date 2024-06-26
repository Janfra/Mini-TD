class_name EnemyDetectionComponent
extends Area3D

signal detected_enemy(enemy : Enemy)

@export_category("Configuration")
@export var range: float

func _on_area_entered(area):
	pass # Replace with function body.


func _on_area_exited(area):
	pass # Replace with function body.
