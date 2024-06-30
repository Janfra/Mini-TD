class_name AttackAnimationComponent
extends Node

@export_category("Dependencies")
@export var attack_component: AttackComponent
@export var animation_type: AttackAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if not attack_component:
		printerr("No attack component set")
		return
	
	if not animation_type:
		printerr("No animation type set")
		return
	
	attack_component.attacked_target.connect(_start_animation.bind())

func _start_animation(enemy : Enemy) -> void:
	var data: AttackAnimation.AttackAnimationData = AttackAnimation.AttackAnimationData.new()
	data.target = enemy
	data.owner = get_parent()
	data.duration = attack_component.attack_duration
	data.duration_type = AttackAnimation.DurationType.Timed
	
	animation_type.start_animation(data)
	

func _physics_process(delta):
	animation_type.update_animation_duration_by(delta)
	
