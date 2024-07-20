class_name AttackAnimationComponent
extends Node

signal on_animation_completed
signal on_animation_ended

@export_category("Dependencies")
@export var animation_type: AttackAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if not animation_type:
		assert(animation_type, "No animation type set")
		return
		
	
	_generate_unique_animation()
	animation_type.bake_values()
	animation_type.completed.connect(_emit_completed_event.bind())
	animation_type.ended.connect(_emit_ended_event.bind())
	

func start_animation(animation_data : AttackAnimation.AttackAnimationData) -> void:
	animation_type.start_animation(animation_data)
	

func end_animation() -> void:
	animation_type.end_animation()
	

func forcefully_stop_animation() -> void:
	animation_type.forcefully_stop_animation()
	

func _emit_completed_event() -> void:
	on_animation_completed.emit()
	

func _emit_ended_event() -> void:
	on_animation_ended.emit()
	

func _physics_process(delta):
	animation_type.update_animation_duration_by(delta)
	

func _generate_unique_animation() -> void:
	animation_type = animation_type.duplicate()
	
