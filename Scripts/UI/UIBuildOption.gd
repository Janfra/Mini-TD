class_name UIBuildOption
extends Button

@export_category("Configuration")
@export var placeable_data: PlaceableData

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Button ready")
	pressed.connect(_selected.bind())
	

func _selected() -> void:
	if not placeable_data:
		printerr("No placement data set on UI Build Button")
		return
	
	print("Selected placeable build option: %s" % placeable_data.to_string())
	GameEvents.update_selected_placeable.emit(placeable_data)
	
