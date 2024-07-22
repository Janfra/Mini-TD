@tool
class_name AnimationSignalData
extends Resource

@export_category("Dependencies")
@export var signal_data: SignalData
@export var animation_name: String
@export var is_reset_queued: bool
@export var stop_current_animation: bool

class AnimationData:
	var animation_name: String
	var is_reset_queued: bool
	var stop_current_animation: bool 
	

func _init():
	signal_data = SignalData.new()
	

func is_valid(listener : AnimationPlayer) -> bool:
	if not signal_data.is_valid(listener):
		return false
	
	return listener.has_animation(animation_name)
	

func get_warning_errors(listener : AnimationPlayer) -> String:
	var found_errors: String
	found_errors += signal_data.get_warning_errors(listener) + " "
	
	if not listener.has_animation(animation_name):
		found_errors += "- Animation Player does not have animation name in library"
		
	
	return found_errors
	

## Connects to callback returning animation data
func connect_to_signal(listener : Node, callback : Callable) -> void:
	## May change to resource for animation data and then put together here instead
	var animation_data = AnimationData.new()
	animation_data.animation_name = animation_name
	animation_data.is_reset_queued = is_reset_queued
	animation_data.stop_current_animation = stop_current_animation
	
	signal_data.connect_to_signal(listener, callback.bind(animation_data))
	

