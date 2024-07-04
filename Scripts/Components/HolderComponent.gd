class_name HolderComponent
extends Node3D

## Enables the placing of objects on component owner

signal placed_object
signal changed_mesh

@export_category("Holding Data")
@export var _placeable: PlaceableData: set = set_placeable
@export var _mesh: MeshInstance3D
@export var _y_offset:float 
var created_scene: Node

func set_placeable(placeable_data : PlaceableData):
	_placeable = placeable_data
	if not placeable_data or not placeable_data.is_valid():
		return
	
	if is_instance_valid(created_scene):
		print("Holder already used")
		return
	
	_generate_placeable(_placeable.placeable_scene)
	placed_object.emit()
	

func change_mesh(set_mesh : Mesh) -> void:
	_mesh.mesh = set_mesh
	

func get_mesh_bounds() -> Vector3:
	if not _mesh or not _mesh.get_aabb():
		assert(false, "There was no valid mesh")
		return Vector3()
	
	return _mesh.get_aabb().size
	

func _generate_placeable(scene : PackedScene):
	if not scene or not scene.can_instantiate():
		assert(false, "Scene cannot be instantiated")
		return
	
	created_scene = scene.instantiate()
	GenerationUtils.setup_node_parent(created_scene, scene.resource_name, self)
	
	var position_offset = global_position
	position_offset.y += get_mesh_bounds().y
	created_scene.global_position = position_offset
	

## TEST: Cursor change
func _on_selectable_component_mouse_entered():
	if is_instance_valid(created_scene):
		PlayerInputs.set_cursor(InputHandler.CursorState.Highlight)
	else:
		PlayerInputs.set_cursor(InputHandler.CursorState.Default)
		
	
