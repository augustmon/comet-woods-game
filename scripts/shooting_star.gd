extends CelestialObject
class_name ShootingStar


@onready var shining_particles: GPUParticles2D = $ShiningParticles

signal player_picked_up

@onready var original_scale = scale
@onready var new_scale = original_scale * 1.4

func grounded_animations() -> void: 
	shining_particles.amount = 65
	var tween = create_tween()
	tween.tween_property(self, "scale", new_scale, 0.1)
	tween.tween_property(self, "scale", original_scale, 1.2)	
	tween.tween_property(self, "scale", new_scale, 0.1)
	tween.tween_property(self, "scale", original_scale, 1.2)	
	
	
func _interact_with_player() -> void:
	GameState.points += 1

