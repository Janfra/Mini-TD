class_name UIGame
extends Control

@export_category("Dependencies")
@export var canvas: CanvasLayer
@export_subgroup("Overlay UI")
@export var lose_screen: PackedScene
@export_subgroup("Top Section")
@export var money_label: Label
@export var health_label: Label
@export var wave_countdown_label: Label
@export_subgroup("Bottom Section")
@export var bottom_section: TabContainer
@export var build_tab: HBoxContainer

@export_category("Configuration")
@export_subgroup("Build Tab")
@export var spacer_size: int = 10
@export var build_option_scene: PackedScene
@export var preloaded_build_options: Array[PlaceableAndUIData]

func _ready():
	Economy.money_changed.connect(set_money_label.bind())
	UIEvents.player_health_updated.connect(set_health_label.bind())
	UIEvents.wave_countdown_started.connect(display_wave_countdown.bind())
	GameManager.lost_game.connect(display_lost_screen.bind())
	GameEvents.wave_spawning_started.connect(hide_countdown.bind())
	
	assert(wave_countdown_label)
	
	for build_option in preloaded_build_options:
		add_build_option(build_option)
		
	

func set_money_label(value : int) -> void:
	money_label.text = "Money: %s" % value
	

func set_health_label(value : int) -> void:
	health_label.text = "Health: %s" % value
	

func display_lost_screen() -> void:
	if lose_screen and lose_screen.can_instantiate():
		GenerationUtils.setup_node_parent(lose_screen.instantiate(), "Lose Overlay", canvas)
		
	print("Display lost screen")
	

func add_build_option(complete_placeable_data : PlaceableAndUIData) -> void:
	if not build_option_scene or not build_option_scene.can_instantiate():
		assert(build_option_scene, "Set a valid build option scene")
		return
	
	var build_option: UIBuildOption = build_option_scene.instantiate() as UIBuildOption
	assert(build_option, "Set the build option scene to have a root node of UIBuildOption type")
	if not build_option:
		return
	
	var spacer: Control = build_tab.add_spacer(false)
	spacer.custom_minimum_size = Vector2(spacer_size, 0)
	spacer.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	## Parent the new build option after the spacer has been added to correctly create margin
	GenerationUtils.setup_node_parent(build_option, "Build Option", build_tab)
	build_option.setup_option_ui(complete_placeable_data)
	

func display_wave_countdown(time : float) -> void:
	wave_countdown_label.visible = true
	wave_countdown_label.text = "Wave starts in: %s" % time
	

func hide_countdown() -> void:
	wave_countdown_label.visible = false
	
