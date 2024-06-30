class_name AttackAnimation
extends Resource

signal completed
@export_category("Configuration")

@export var duration_type: DurationType

class AttackAnimationData:
	var target: Node3D = null
	var owner: Node3D = null
	var duration: float = 0.0
	
	func is_valid() -> bool:
		return is_instance_valid(target) and is_instance_valid(owner)
	

enum DurationType
{
	Timed,
	Infinite,
}

func bake_values() -> void:
	pass
	

func start_animation(animation_data : AttackAnimationData) -> void:
	pass
	

func stop_animation() -> void:
	pass
	

func update_animation_duration_by(value : float) -> void:
	pass
	
