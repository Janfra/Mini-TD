@tool
class_name LifetimeAndAnimationNode3D
extends LifetimeNode3D

@export_category("Depedencies")
@export var animation_player: AnimationPlayer: 
	set(set_animation_player):
		animation_player = set_animation_player
		if animation_player.has_animation(END_LIFETIME_ANIMATION):
			return
		
		var global_library = animation_player.get_animation_library("")
		if not global_library:
			animation_player.add_animation_library("", AnimationLibrary.new())
			global_library = animation_player.get_animation_library("")
		
		global_library.add_animation(END_LIFETIME_ANIMATION, Animation.new())
		
	

const END_LIFETIME_ANIMATION = "END OF LIFETIME"

func _ready():
	assert(animation_player, "No animation player set")
	assert(animation_player.has_animation(END_LIFETIME_ANIMATION), "No animation will be played at end of lifetime")
	
	var min_lifetime: float = get_minimum_lifetime()
	if lifetime < min_lifetime:
		lifetime = min_lifetime
	

func end_of_lifetime() -> void:
	animation_player.stop()
	animation_player.clear_queue()
	animation_player.play(END_LIFETIME_ANIMATION)
	super()
	

func set_lifetime(set_lifetime : float) -> void:
	if not animation_player:
		lifetime = set_lifetime
		return
	
	lifetime = max(set_lifetime, get_minimum_lifetime())
	

func get_minimum_lifetime() -> float:
	return animation_player.get_animation(END_LIFETIME_ANIMATION).length
	
