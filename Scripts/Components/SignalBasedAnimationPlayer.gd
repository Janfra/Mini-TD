@tool
class_name SignalBasedAnimationPlayer
extends AnimationPlayer

const RESET_ANIMATION = "RESET"

@export_category("Dependencies")
@export var signals: Array[AnimationSignalData]

@export_category("Debugging")
## Pressed in inspector to check if signals are valid
@export var is_valid: bool: set = _validate_signals

func _get_configuration_warnings() -> PackedStringArray:
	var found_errors: PackedStringArray
	
	if not is_valid:
		var index: int = 0
		for animation_signal in signals:
			var errors = animation_signal.get_warning_errors(self)
			if not errors.is_empty():
				found_errors.append("Signal Data #%s errors: " % index + errors)
			index += 1
		
	
	return found_errors
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for animation_signal in signals:
		animation_signal.connect_to_signal(self, _play_animation.bind())
		
	

func _play_animation(animation_data : AnimationSignalData.AnimationData) -> void:
	if animation_data.stop_current_animation and is_playing():
		stop()
	
	play(animation_data.animation_name)
	
	if animation_data.is_reset_queued:
		queue(RESET_ANIMATION)
		
		## Just in case we start stacking resets, let me know
		if get_queue().count(RESET_ANIMATION) > 1:
			printerr("WARNING: Several animation resets being queued: %s" %get_queue())
			
	

func _validate_signals(_validate : bool) -> void:
	if not Engine.is_editor_hint():
		return
	
	is_valid = true
	for animation_signal in signals:
		if not animation_signal.is_valid(self):
			is_valid = false
			break
	
	update_configuration_warnings()
	
