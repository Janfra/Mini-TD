class_name PlaceableAndUIData
extends Resource

@export_category("Dependencies")
@export var placeable_data: PlaceableData

@export_category("Configuration")
@export var image: Texture
@export var name: String

func is_valid() -> bool:
	return placeable_data.is_valid() and image and not name.is_empty()
	
