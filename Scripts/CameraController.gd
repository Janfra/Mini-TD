class_name CameraController
extends Camera3D

## Handles camera movement

@export_category("Movement Configuration")
@export var _acceleration_rate: float = 1.0
@export var _max_speed: float = 5.0
@export var movement_limits: Vector4

var _velocity:Vector3 = Vector3.ZERO
var _velocity_last_frame:Vector3 = Vector3.ZERO

@onready var left_limit = %Left_limit
@onready var right_limit = %Right_limit
@onready var up_limit = %Up_limit
@onready var down_limit = %Down_limit

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerInputs.moved.connect(_perform_camera_movement.bind())
	PlayerInputs.stopped_moving.connect(stop_movement.bind())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += _velocity
	

func stop_movement() -> void:
	_velocity = Vector3.ZERO
	

func _perform_camera_movement(move_input : Vector2) -> void:
	var normalized_input:Vector2 = move_input.normalized()
	var movement: Vector3 = Vector3.ZERO
	movement.x = normalized_input.x
	movement.z = normalized_input.y
	
	var acceleration = movement * _acceleration_rate
	_velocity += acceleration
	if _velocity.length_squared() > _max_speed * _max_speed:
		_velocity = _velocity_last_frame
		return
	
	_velocity_last_frame = _velocity
	

func _check_camera_constraints() -> void:
	pass
	
