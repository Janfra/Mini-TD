class_name InputHandler
extends Node

## Input designed to assume there will only be one player for simplicity

signal moved(MoveInput : Vector2)
signal stopped_moving
signal clicked(event : InputEventMouseButton)
signal just_clicked(event : InputEventMouseButton)
signal stopped_clicking(event : InputEventMouseButton)

var _was_moving:bool = false
var _ui_focused:bool = false

func _unhandled_input(event) -> void:
	_handle_movement_inputs()
	if event is InputEventMouseButton:
		_handle_clicking(event as InputEventMouseButton)
		
	

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
		
	

func _handle_clicking(event : InputEventMouseButton) -> void:
	clicked.emit(event)
	
	if event.is_pressed():
		just_clicked.emit(event)
	else:
		stopped_clicking.emit(event)
	
