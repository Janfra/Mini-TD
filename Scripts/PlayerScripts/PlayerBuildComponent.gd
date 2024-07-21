class_name PlayerBuildComponent
extends Node

@export_category("Configuration")
@export var start_money: int = 5

@export_category("Debugging")
@export var _placeable: PlaceableData

func _ready():
	Economy.add_money(start_money)
	GameEvents.update_selected_placeable.connect(_set_selected_placeable.bind())
	

func setup(player_camera : CameraController) -> void:
	player_camera.player_selected.connect(_selected.bind())
	

func _set_selected_placeable(set_placeable : PlaceableData) -> void:
	if set_placeable and !set_placeable.is_valid():
		printerr("Setting invalid placeable as selected placeable")
		return
		
	
	_placeable = set_placeable
	

func _selected(selectable : SelectableComponent) -> void:
	if not _placeable or not _placeable.is_valid():
		return
	
	if not Economy.has_required_amount_of_money(_placeable.cost):
		return
	
	if selectable.selected_node is HolderComponent:
		var holder = selectable.selected_node as HolderComponent
		holder.set_placeable(_placeable)
		Economy.remove_money(_placeable.cost)
	else:
		printerr("Not holder component - %s" % selectable.selected_node)
	
