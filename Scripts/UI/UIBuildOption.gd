class_name UIBuildOption
extends Button

@export_category("Dependencies")
@export var building_image: TextureRect
@export var name_label: Label
@export var cost_label: Label

@export_category("Configuration")
@export var placeable_data: PlaceableData

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_selected.bind())
	

func setup_option_ui(complete_placeable_data : PlaceableAndUIData) -> void:
	if not complete_placeable_data.is_valid():
		return
	
	assert(name_label, "Set the name label reference")
	name_label.text = complete_placeable_data.name
	
	assert(building_image, "Set the building image reference")
	building_image.texture = complete_placeable_data.image
	
	# TEST: Change to use placeable cost
	assert(cost_label, "Set the cost label reference")
	cost_label.text = "Test - Cost"
	
	placeable_data = complete_placeable_data.placeable_data
	

func _selected() -> void:
	if not placeable_data:
		printerr("No placement data set on UI Build Button")
		return
	
	print("Selected placeable build option: %s" % placeable_data.to_string())
	GameEvents.update_selected_placeable.emit(placeable_data)
	
