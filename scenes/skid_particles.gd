extends CPUParticles2D

@onready var player: Player = $".."

func emit() -> void:
	scale.x = -(player.player_sprites.scale.x)
	emitting = true
