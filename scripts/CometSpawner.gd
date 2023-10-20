extends Node2D
class_name CometSpawner
#Preload comet scene
const COMET = preload("res://scenes/comet.tscn")

# Reference to ground to generate spawn coordinates
@onready var ground: StaticBody2D = $"../Ground"
var ground_center : Vector2

func _ready() -> void:
	ground_center = ground.global_position
	print(ground_center)
	
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_comet()
	
func spawn_comet() -> void:
	var new_comet = COMET.instantiate()
	new_comet.spawn_point = random_spawn_position()
	new_comet.ground_point = ground_center
	var random_float = randf_range(1.0,2.0)
	new_comet.scale = Vector2(random_float, random_float)
	add_child(new_comet)
	
	
func random_spawn_position() -> Vector2:
	var random_y_coord = randi_range(0, ground_center.y)
	var fortegn = [-random_y_coord, +random_y_coord]
	var y_coord_plus_or_minus = fortegn[randi_range(0,1)]
	var calculated_x_coord = ground_center.x + y_coord_plus_or_minus*2
	var spawn_point_vector = Vector2(calculated_x_coord, random_y_coord)
	return spawn_point_vector


func _on_spawntimer_timeout() -> void:
	spawn_comet()
