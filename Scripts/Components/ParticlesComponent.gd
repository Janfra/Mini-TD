class_name ParticlesComponent
extends Node

## Handles the logic for particles emittion and lifetime

@export_category("Dependencies")
@export var target: NotifiedNode3D
@export var particles: GPUParticles3D

@export_category("Configuration")
@export var is_auto_play: bool
@export var duration_type: ParticleLifetimeDuration

enum ParticleLifetimeDuration
{
	TargetLifetime,
	Duration
}

func _ready():
	if is_auto_play:
		emit_particles()
	
	if duration_type == ParticleLifetimeDuration.TargetLifetime:
		target.freed.connect(stop_emittion.bind())
		target.lifetime = particles.lifetime
		

func emit_particles() -> void:
	particles.emitting = true
	

func stop_emittion() -> void:
	particles.emitting = false
	
