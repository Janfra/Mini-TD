class_name AttackAnimation
extends Resource

signal completed
signal ended

@export_category("Configuration")

@export var duration_type: DurationType

class AttackAnimationData:
	var target: Node3D = null
	var owner: Node3D = null
	var velocity: float = 0.0
	var duration: float = 0.0
	var static_position: Vector3
	
	func is_valid() -> bool:
		return is_instance_valid(target) and is_instance_valid(owner)
	
	func set_duration_based_on_velocity() -> void:
		if not is_valid():
			printerr("Tried to set the animation data duration without valid data")
			return
		
		var path = target.global_position - owner.global_position
		var distance_squared = path.length_squared()
		duration = distance_squared / (velocity * velocity)
	
	func set_static_target_position() -> void:
		static_position = target.global_position
		
	

enum DurationType
{
	Timed,
	Infinite,
}

func bake_values() -> void:
	pass
	

func start_animation(animation_data : AttackAnimationData) -> void:
	pass
	

func end_animation() -> void:
	pass
	

func forcefully_stop_animation() -> void:
	pass
	

func update_animation_duration_by(value : float) -> void:
	pass
	
