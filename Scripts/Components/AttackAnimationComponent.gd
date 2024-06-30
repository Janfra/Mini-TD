class_name AttackAnimationComponent
extends Node

signal on_animation_completed

@export_category("Dependencies")
@export var animation_type: AttackAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if not animation_type:
		assert(animation_type, "No animation type set")
		return
	animation_type.bake_values()
	animation_type.completed.connect(_emit_completed_event.bind())
	

func start_animation(animation_data : AttackAnimation.AttackAnimationData) -> void:
	animation_type.start_animation(animation_data)
	

func _emit_completed_event() -> void:
	on_animation_completed.emit()
	

func _physics_process(delta):
	animation_type.update_animation_duration_by(delta)
	
