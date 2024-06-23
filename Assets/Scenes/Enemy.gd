class_name Enemy
extends Node3D

@export_category("Dependencies")
@export var path_follower: PathFollowerComponent

## TBD: Setup components based on resource data?
func _ready():
	path_follower.target = self
	
