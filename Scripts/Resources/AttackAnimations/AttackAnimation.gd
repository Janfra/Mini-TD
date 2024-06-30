class_name AttackAnimation
extends Resource

signal completed
signal started

class AttackAnimationData:
	var target: Node3D
	var owner: Node3D
	var duration_type: DurationType
	var duration: float
	
	func is_valid() -> bool:
		return is_instance_valid(target) and is_instance_valid(owner)
	

enum DurationType
{
	Timed,
	Infinite,
}

func start_animation(animation_data : AttackAnimationData) -> void:
	pass
	

func stop_animation() -> void:
	pass
	

func update_animation_duration_by(value : float) -> void:
	pass
	
