class_name BulletAnimation
extends AttackAnimation

@export_category("Dependency")
@export var animation_scene: PackedScene
@export var is_looking_at_target: bool = false
@export var travel_speed: Curve

var _generated_bullets: Array[BulletData]

class BulletData:
	var bullet: Node3D
	var current_duration: float
	var animation_data : AttackAnimationData
	
	func _init(set_bullet : Node3D, set_animation_data : AttackAnimationData) -> void:
		bullet = set_bullet
		animation_data = set_animation_data
		
	
	func is_valid() -> bool:
		return is_instance_valid(bullet) and animation_data.is_valid()
		
	
	func update_progress_by(value : float) -> bool:
		current_duration += value
		return current_duration >= animation_data.duration
		
	
	func get_progress_value() -> float:
		if current_duration > animation_data.duration:
			current_duration = animation_data.duration
		
		return MathUtils.normalise_range(current_duration, 0, animation_data.duration)
		
	
	func look_at_target() -> void:
		bullet.look_at(animation_data.target.global_position)
		
	
	func update_bullet_position(progress : float) -> void:
		var updated_position: Vector3 = animation_data.target.global_position
		var start_position: Vector3 = animation_data.owner.global_position
		bullet.global_position = lerp(start_position, updated_position, progress)
		
	
	func clear_bullet() -> void:
		if is_instance_valid(bullet):
			bullet.queue_free()
			
		
	

func is_valid() -> bool:
	return animation_scene and animation_scene.can_instantiate()
	

func bake_values() -> void:
	travel_speed.bake()
	assert(duration_type != DurationType.Infinite, "Bullets dont support infinite duration")
	

func start_animation(animation_data : AttackAnimationData) -> void:
	if not is_valid() or not animation_data.is_valid():
		printerr("Bullet Animation could not be started")
		return
	
	_generate_bullet(animation_data)
	

func stop_animation() -> void:
	print("Stopped animating")
	

func update_animation_duration_by(value : float) -> void:
	if _generated_bullets.is_empty():
		return
	
	for bullet in _generated_bullets:
		if not bullet.is_valid():
			bullet.clear_bullet()
			_generated_bullets.erase(bullet)
			printerr("Animation has an invalid bullet")
			continue
		
		var is_completed: bool = bullet.update_progress_by(value)
		var progress = bullet.get_progress_value()
		progress = travel_speed.sample_baked(progress)
		bullet.update_bullet_position(progress)
		
		if is_completed:
			completed.emit()
			_generated_bullets.erase(bullet)
			bullet.clear_bullet()
			continue
		
		if is_looking_at_target:
			bullet.look_at_target()
		
	

func _generate_bullet(animation_data : AttackAnimationData) -> void:
	var bullet: Node3D = animation_scene.instantiate()
	assert(bullet, "Bullet generation failed")
	GenerationUtils.setup_node_parent(bullet, "Bullet", animation_data.owner)
	
	var data: BulletData = BulletData.new(bullet, animation_data)
	_generated_bullets.append(data)
	
