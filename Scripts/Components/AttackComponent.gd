class_name AttackComponent
extends Node

signal attacked_target(enemy : Enemy)

@export_category("Configuration")
@export var damage: int = 1
@export var attack_speed: float = 1
@export var attack_duration: float = 1
@export var max_targets: int = 1
@export var target_priority: FocusPriority

var attack_timer: Timer
var available_targets: Array[Enemy]

enum FocusPriority
{
	First,
	Last,
	Random,
}

func _ready() -> void:
	_setup_attack_timer()
	

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
	attack_timer.timeout.connect(_attack_target.bind())
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
	

func _attack_target() -> void:
	var target: Enemy = available_targets.front() as Enemy
	assert(target, "Timer should be disabled when all targets are removed")
	print("Attacking %s" % target.name)
	
	target.connect_to_dead_event(_target_killed.bind(target))
	target.deal_damage(damage)
	attacked_target.emit(target)
	

func _target_killed(enemy : Enemy) -> void:
	enemy.disconnect_to_dead_event(_target_killed.bind())
	remove_attacking_target(enemy)
	print("Killed target")
	
