@tool
class_name NotifiedAndAnimationNode3D
extends NotifiedNode3D

@export_category("Depedencies")
@export var animation_player: AnimationPlayer: 
	set(set_animation_player):
		animation_player = set_animation_player
		if animation_player.has_animation(END_LIFETIME_ANIMATION):
			return
		
		var global_library = animation_player.get_animation_library("")
		global_library.add_animation(END_LIFETIME_ANIMATION, Animation.new())
		
	

const END_LIFETIME_ANIMATION = "END OF LIFETIME"

func _ready():
	assert(animation_player, "No animation player set")

func end_of_lifetime() -> void:
	animation_player.play(END_LIFETIME_ANIMATION)
	super()
	

func set_lifetime(set_lifetime : float) -> void:
	if not animation_player:
		lifetime = set_lifetime
		return
	
	lifetime = max(set_lifetime, animation_player.get_animation(END_LIFETIME_ANIMATION).length)
	
