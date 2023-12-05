extends CelestialObject
class_name ShootingStar


@onready var shining_particles: GPUParticles2D = $ShiningParticles

signal player_picked_up

func grounded_animations() -> void: 
	shining_particles.amount = 24
	
func _interact_with_player() -> void:
	GameState.points += 1

