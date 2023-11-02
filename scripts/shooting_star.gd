extends CelestialObject
class_name ShootingStar


func _ready() -> void:
	set_collision_shapes()
	set_position_and_direction()
	set_size_scale() 
	set_life_span()
	SPEED = 0.1
	WAIT_TIME = 2.0


func give_point() -> void:
	pass
