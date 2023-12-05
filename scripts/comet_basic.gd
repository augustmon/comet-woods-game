extends CelestialObject
class_name CometBasic


@onready var smoke_trail: CPUParticles2D = $SmokeTrail
@onready var firetail: Node2D = $Firetail
@onready var ground_smoke: GPUParticles2D = $GroundSmoke


const DEATH_EXPLOSION = preload("res://scenes/death_explosion.tscn")


func _on_ground_collision_entered(area: Area2D) -> void:
	if not celestial_object_data.wait_time and not extra_waiting_time:
		var new_explosion = DEATH_EXPLOSION.instantiate()
		queue_free()
		
	else:
		grounded = true
		await get_tree().create_timer(celestial_object_data.wait_time + extra_waiting_time).timeout
		create_explosion()
		queue_free()


func _interact_with_player() -> void: 
	GameState.health -= 1
	create_explosion() 


func create_explosion() -> void:
	var new_explosion = DEATH_EXPLOSION.instantiate()
	new_explosion.position = position
	new_explosion.emitting = true
	get_parent().add_child(new_explosion) 


func grounded_animations() -> void: 
	smoke_trail.emitting = false
	var smoke_direction =  SPAWN_POINT - TARGET_POINT
	ground_smoke.process_material.gravity = Vector3(smoke_direction.x, smoke_direction.y, 0)
	ground_smoke.emitting = true
	
	
	
