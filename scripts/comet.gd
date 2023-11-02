extends Celestial
class_name Comet

#TODO: 
# # Deal damage function 


func _ready() -> void:
	set_collision_shapes()
	set_position_and_direction()
	set_size_scale() 
	set_life_span()
	
func _process(delta: float) -> void:
	var linear_velocity = direction * SPEED
	position += linear_velocity * delta

#func set_position_and_direction() -> void:
	#position = SPAWN_POINT
	#TARGET_POINT = Vector2.ZERO
	#direction = TARGET_POINT - SPAWN_POINT

#func set_collision_shapes() -> void:
	#collision_polygon_2d.polygon = polygon_2d.polygon
	#hit_area.polygon = polygon_2d.polygon	
#
#func set_size_scale() -> void:
	#var random_scale = randf_range(1.0,3.0)
	#set_scale(Vector2(random_scale,random_scale))
	#
#func set_life_span() -> void:
	#var timer : Timer = Timer.new()
	#add_child(timer)
	#timer.one_shot = true
	#timer.autostart = false
	#timer.wait_time = LIFE_SPAN
	#timer.timeout.connect(func(): queue_free()) # this is a lambda/callback function
	#timer.start()
#
#func _on_hit_area_area_entered(area: Area2D) -> void:
	#queue_free()

