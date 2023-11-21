extends CelestialObject
class_name CometBasic


@onready var smoke_trail: CPUParticles2D = $SmokeTrail
@onready var firetail: Node2D = $Firetail
@onready var death_explosion: GPUParticles2D = $DeathExplosion

const DEATH_EXPLOSION = preload("res://scenes/death_explosion.tscn")

#func deal_damage() -> void:
	#GameState.health -= 1

func grounded_animations() -> void: 
	smoke_trail.emitting = false
	#polygon_2d.visible = false
	death_explosion.emitting = true
	
	
func _interact_with_player() -> void: 
	var new_explosion = DEATH_EXPLOSION.instantiate()
	new_explosion.position = position
	new_explosion.emitting = true
	get_parent().add_child(new_explosion) 
	queue_free()
