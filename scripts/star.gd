extends Celestial
class_name Star

func _ready() -> void:
	set_collision_shapes()
	set_position_and_direction()
	set_size_scale() 
	set_life_span()
	
func _process(delta: float) -> void:
	var linear_velocity = direction * SPEED
	position += linear_velocity * delta
