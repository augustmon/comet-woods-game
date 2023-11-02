extends StaticBody2D
class_name CelestialObject


@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var hit_area: CollisionPolygon2D = $HitArea.get_child(0)

@export var SPAWN_POINT : Vector2 = Vector2(600,300)
@export var TARGET_POINT : Vector2 = Vector2(1200,600)
@export var SPEED : float = 0.2
@export var LIFE_SPAN : float = 10.0
@export var WAIT_TIME : float = 0

var grounded : bool = false
var direction : Vector2 

func _ready() -> void:
	set_collision_shapes()
	set_position_and_direction()
	set_size_scale() 
	set_life_span()
	
func _process(delta: float) -> void:
	if not grounded:
		var linear_velocity = direction * SPEED
		position += linear_velocity * delta

func set_position_and_direction() -> void:
	position = SPAWN_POINT
	TARGET_POINT = Vector2.ZERO
	direction = TARGET_POINT - SPAWN_POINT

func set_collision_shapes() -> void:
	collision_polygon_2d.polygon = polygon_2d.polygon
	hit_area.polygon = polygon_2d.polygon	

func set_size_scale() -> void:
	var random_scale = randf_range(1.0,3.0)
	set_scale(Vector2(random_scale,random_scale))
	
func set_life_span() -> void:
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = LIFE_SPAN
	timer.timeout.connect(func(): queue_free()) # this is a lambda/callback function
	timer.start()


# if hitting ground
func _on_hit_area_area_entered(area: Area2D) -> void:
	var name_of_object = area.get_parent().name
	if name_of_object == "Player" or name_of_object == "Ground":			
		if not WAIT_TIME:
			queue_free()
		else:
			grounded = true
			await get_tree().create_timer(WAIT_TIME).timeout
			queue_free()
	else: 
		pass
