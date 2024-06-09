class_name InputHandler
extends Node

## Input designed to assume there will only be one player for simplicity

signal moved(MoveInput : Vector2)
signal stopped_moving
signal clicked

var _was_moving:bool = false
var _ui_focused:bool = false

func _unhandled_input(event):
	_handle_movement_inputs()
	

func set_ui_focused(is_focused : bool) -> void:
	_ui_focused = is_focused
	# Clear inputs?
	

func _handle_movement_inputs() -> void:
	if _ui_focused:
		return
	
	var verticalMovement = Input.get_axis("move_up", "move_down")
	var horizontalMovement = Input.get_axis("move_left", "move_right")
	var movementInput = Vector2(horizontalMovement, verticalMovement)
	if movementInput.length_squared() > 0:
		moved.emit(movementInput)
		_was_moving = true
		
	elif _was_moving:
		stopped_moving.emit()
		_was_moving = false
		
	

func _handle_clicking() -> void:
	if not Input.is_action_just_pressed("select"):
		return
	
	clicked.emit()
	
