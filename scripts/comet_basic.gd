extends CelestialObject
class_name CometBasic

@onready var fire_tail: Polygon2D = $FireTail

func _ready() -> void:
	set_collision_shapes()
	set_position_and_direction()
	set_size_scale() 
	set_life_span()
	SPEED = 0.2
	
func _process(delta: float) -> void:
	var linear_velocity = direction * SPEED
	position += linear_velocity * delta
	var angle = atan2(linear_velocity.y, linear_velocity.x)
	var degrees = rad_to_deg(angle)
	rotation_degrees = degrees
	#fire_tail.rotate(radians)


func deal_damage() -> void:
	pass
