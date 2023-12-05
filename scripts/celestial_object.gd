extends StaticBody2D
class_name CelestialObject


@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var hit_area: CollisionPolygon2D = $HitArea.get_child(0)
@onready var ground_collision: Area2D = $GroundCollision
@onready var ground_collision_polygon: CollisionPolygon2D = $GroundCollision/GroundCollisionPolygon

@export var SPAWN_POINT : Vector2 = Vector2(600,300)
@export var TARGET_POINT : Vector2 = Vector2(1200,600)
@export var celestial_object_data : CelestialObjectData
@export var speed_multiplier : float = 1.0
@export var extra_waiting_time : float

var grounded : bool = false
var direction : Vector2 



func _ready() -> void:
	set_collision_shapes()
	set_position_and_direction()
	set_size_scale() 
	set_life_span()
	ground_collision.area_entered.connect(_on_ground_collision_entered)
	
	
	
func _process(delta: float) -> void:
	if not grounded:
		var linear_velocity = direction * speed_multiplier * celestial_object_data.speed
		position += linear_velocity * delta
		var angle = atan2(linear_velocity.y, linear_velocity.x)
		var degrees = rad_to_deg(angle)
		rotation_degrees = degrees
	if grounded:
		grounded_animations() 


func set_position_and_direction() -> void:
	position = SPAWN_POINT
	TARGET_POINT = Vector2.ZERO
	direction = TARGET_POINT - SPAWN_POINT


func set_collision_shapes() -> void:
	collision_polygon_2d.polygon = polygon_2d.polygon
	hit_area.polygon = polygon_2d.polygon	
	ground_collision_polygon.polygon = polygon_2d.polygon


func set_size_scale() -> void:
	var random_scale = randf_range(1.0,3.0)
	set_scale(Vector2(random_scale,random_scale))

	
func set_life_span() -> void:
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = celestial_object_data.life_span
	timer.timeout.connect(func(): queue_free()) # this is a lambda/callback function
	timer.start()


func grounded_animations() -> void: 
	pass


func _interact_with_player() -> void:
	pass


##TODO Refactor so that two differnet functions handle this
func _on_hit_area_area_entered(area: Area2D) -> void:
	# if hitting player
	var name_of_object = area.get_parent().name
	if name_of_object == "Player":
		_interact_with_player()
		queue_free()


func _on_ground_collision_entered(area: Area2D) -> void:
	if not celestial_object_data.wait_time and not extra_waiting_time:
		queue_free()
		
	else:
		grounded = true
		await get_tree().create_timer(celestial_object_data.wait_time + extra_waiting_time).timeout
		queue_free()
	
