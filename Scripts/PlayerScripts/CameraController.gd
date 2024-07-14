class_name CameraController
extends Camera3D

## Handles camera movement

@export_category("Movement Configuration")
@export var _speed: float = 1.0

@export_category("Debugging")
@export var _placeable: PlaceableData

var _velocity:Vector3 = Vector3.ZERO
var _velocity_last_frame:Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInputs.moved.connect(_perform_camera_movement.bind())
	PlayerInputs.stopped_moving.connect(stop_movement.bind())
	PlayerInputs.just_clicked.connect(_try_select.bind())
	GameEvents.update_selected_placeable.connect(_set_selected_placeable.bind())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float) -> void:
	if not _velocity.is_zero_approx():
		global_position += _velocity * delta
	

func stop_movement() -> void:
	_velocity = Vector3.ZERO
	

func _perform_camera_movement(move_input : Vector2) -> void:
	var normalized_input:Vector2 = move_input.normalized()
	var movement: Vector3 = Vector3.ZERO
	movement.x = normalized_input.x
	movement.z = normalized_input.y
	
	_velocity = movement * _speed
	

func _try_select(event : InputEventMouseButton) -> void:
	if not _placeable or not _placeable.is_valid():
		return
		
	
	var space = get_world_3d().direct_space_state
	var start = project_ray_origin(event.position)
	var end = start + project_ray_normal(event.position) * 1000
	var ray = PhysicsRayQueryParameters3D.create(start, end)
	ray.collide_with_areas = true
	var array = space.intersect_ray(ray)
	
	if array.is_empty():
		printerr("Selection failed")
		return
	
	# TEST: Selecting and building
	if array.collider is SelectableComponent:
		var selectable = array.collider as SelectableComponent
		if selectable.selected_node is HolderComponent:
			var holder = selectable.selected_node as HolderComponent
			holder.set_placeable(_placeable)
		else:
			printerr("Not holder component - %s" % array.collider)
	else:
		printerr("Not selectable - %s" % array.collider)
	

func _set_selected_placeable(set_placeable : PlaceableData) -> void:
	if set_placeable and !set_placeable.is_valid():
		printerr("Setting invalid placeable as selected placeable")
		return
		
	
	_placeable = set_placeable
	
