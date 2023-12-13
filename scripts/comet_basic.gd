extends CelestialObject
class_name CometBasic


const DEATH_EXPLOSION = preload("res://scenes/death_explosion.tscn")
@onready var smoke_trail: CPUParticles2D = $SmokeTrail
@onready var firetail: Node2D = $Firetail
@onready var ground_smoke: GPUParticles2D = $GroundSmoke
@onready var nose_marker: Marker2D = $NoseMarker


func _on_ground_collision_entered(area: Area2D) -> void:
	if not celestial_object_data.wait_time and not extra_waiting_time:
		create_explosion()
		queue_free()
	else:
		grounded = true
		await get_tree().create_timer(celestial_object_data.wait_time + extra_waiting_time).timeout
		create_explosion()
		queue_free()


func _interact_with_player() -> void: 
	GameState.health -= 1


func create_explosion() -> void:
	var new_explosion = DEATH_EXPLOSION.instantiate()
	new_explosion.position = position
	new_explosion.emitting = true
	new_explosion.scale = scale / 2
	get_parent().add_child(new_explosion)
	if new_explosion.get_child(0):
		new_explosion.get_child(0).emitting = true


func grounded_animations() -> void: 
	smoke_trail.emitting = false
	var smoke_direction =  (TARGET_POINT - SPAWN_POINT).normalized()
	ground_smoke.process_material.gravity = Vector3(smoke_direction.x * 10, smoke_direction.y * 10, 0)
	ground_smoke.emitting = true
	
	
	
