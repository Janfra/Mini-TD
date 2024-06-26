class_name PlaceableData
extends Resource

## Holds data related to placeable object

@export var placeable_scene: PackedScene

func is_valid() -> bool:
	return placeable_scene and placeable_scene.can_instantiate()
	
