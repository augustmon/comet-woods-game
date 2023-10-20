extends RigidBody2D
class_name Comet

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var death_timer: Timer = $DeathTimer
@onready var hit_area_collision: CollisionPolygon2D = $HitArea/HitAreaCollision

@export var spawn_point : Vector2
@export var ground_point : Vector2
@export var speed : float = 0.3
var direction : Vector2 

func _ready() -> void:
	collision_polygon_2d.polygon = polygon_2d.polygon
	hit_area_collision.polygon = polygon_2d.polygon
	
	position = spawn_point
	direction = ground_point - spawn_point
	
	death_timer.start()
	
func _process(delta: float) -> void:
	linear_velocity = direction * speed
	move_and_collide(linear_velocity, delta)
	

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_hit_area_area_entered(area: Area2D) -> void:
	print("hitting", area)
	queue_free()
