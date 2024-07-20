class_name AttackComponent
extends Node

signal selected_target(enemy : Enemy)
signal before_attacking_target(enemy : Enemy)

@export_category("Soft Dependencies")
@export var animation_component: AttackAnimationComponent

@export_category("Configuration")
@export var damage: int = 1
@export var attack_speed: float = 1
@export var attack_velocity: float = 1
@export var max_targets: int = 1
@export var target_priority: FocusPriority

var attack_timer: Timer
var available_targets: Array[Enemy]
var current_target: Enemy

enum FocusPriority
{
	First,
	Last,
	Random,
}

func _ready() -> void:
	_setup_attack_timer()
	if animation_component:
		animation_component.on_animation_completed.connect(_attack_target.bind())
		
	

func add_attacking_target(enemy : Enemy) -> void:
	available_targets.append(enemy)
	_try_start_attacking_timer()
	

func remove_attacking_target(enemy : Enemy) -> void:
	var index = available_targets.find(enemy)
	if index < 0:
		return
	available_targets.remove_at(index)
	_check_for_attacking()
	

func _setup_attack_timer() -> void:
	attack_timer = Timer.new()
	attack_timer.timeout.connect(_start_attack.bind())
	attack_timer.one_shot = false
	GenerationUtils.setup_node_parent(attack_timer, "Attack Speed Timer", self)
	

func _check_for_attacking() -> void:
	if not available_targets.is_empty():
		return
	attack_timer.stop()
	

func _try_start_attacking_timer() -> void:
	if not attack_timer.is_stopped():
		return
	
	attack_timer.start(attack_speed)
	if not current_target:
		_set_current_target()
	

func _start_attack() -> void:
	if not current_target:
		_set_current_target()
	
	if animation_component:
		_start_animation(current_target)
		
	else:
		_attack_target()
		
	

func _start_animation(target : Node3D) -> void:
	var animation_data: AttackAnimation.AttackAnimationData = AttackAnimation.AttackAnimationData.new()
	animation_data.owner = owner
	animation_data.target = target
	animation_data.velocity = attack_velocity
	animation_data.set_duration_based_on_velocity()
	
	animation_component.start_animation(animation_data)
	

func _select_target() -> Enemy:
	var target: Enemy = available_targets.front() as Enemy
	assert(target, "Timer should be disabled when all targets are removed")
	selected_target.emit(target)
	return target
	

func _set_current_target() -> void:
	current_target = _select_target()
	current_target.connect_to_dead_event(_target_killed.bind())
	

func _attack_target() -> void:
	if not is_instance_valid(current_target) and not current_target:
		return
	
	before_attacking_target.emit(current_target)
	current_target.deal_damage(damage)
	

func _target_killed() -> void:
	if animation_component:
		animation_component.end_animation()
	
	current_target.disconnect_to_dead_event(_target_killed.bind())
	remove_attacking_target(current_target)
	current_target = null
	
