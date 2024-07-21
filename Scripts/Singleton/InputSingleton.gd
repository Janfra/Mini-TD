extends Node

## Input designed to assume there will only be one player for simplicity

signal moved(MoveInput : Vector2)
signal stopped_moving
signal clicked(event : InputEventMouseButton)
signal just_clicked(event : InputEventMouseButton)
signal stopped_clicking(event : InputEventMouseButton)

var _was_moving:bool = false
var _ui_focused:bool = false

const DEFAULT_POINTER = preload("res://Assets/Pointers/pointer_c_shaded.png")
const HIGHLIGHT_POINTER = preload("res://Assets/Pointers/outline_pointer_c.png")
const BUILD_POINTER = preload("res://Assets/Pointers/tool_hammer_outline.png")

enum CursorState
{
	Default,
	Highlight,
	Build,
}

func _ready() -> void:
	Input.set_custom_mouse_cursor(_get_cursor_from_state(CursorState.Highlight), Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(_get_cursor_from_state(CursorState.Build), Input.CURSOR_CAN_DROP)
	

func _unhandled_input(event) -> void:
	_handle_movement_inputs()
	if event is InputEventMouseButton:
		_handle_clicking(event as InputEventMouseButton)
		
	

func set_ui_focused(is_focused : bool) -> void:
	_ui_focused = is_focused
	# Clear inputs?
	

func set_cursor(state : CursorState) -> void:
	Input.set_custom_mouse_cursor(_get_cursor_from_state(state))
	

func _get_cursor_from_state(state : CursorState) -> CompressedTexture2D:
	match state:
		CursorState.Default:
			return DEFAULT_POINTER
		
		CursorState.Highlight:
			return HIGHLIGHT_POINTER
		
		CursorState.Build:
			return BUILD_POINTER
		
	
	return DEFAULT_POINTER
	

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
	
