extends Node2D
class_name CometSpawner
#Preload comet scene
const COMET = preload("res://scenes/comet.tscn")

# Reference to ground to generate spawn coordinates
@onready var ground: StaticBody2D = %Ground
var ground_center : Vector2

@onready var spawntimer: Timer = $Spawntimer

@export var radius : int = 1600

func _ready() -> void:
	ground_center = Vector2.ZERO
	spawntimer.start()
	
func _process(delta: float) -> void:
	pass
	
## TESTING: Comet spawn on 'Enter' key
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_comet()
##
	
func spawn_comet() -> void:
	var new_comet = COMET.instantiate()
	new_comet.SPAWN_POINT = random_spawn_position()
	get_parent().add_child(new_comet)
	
	
func random_spawn_position() -> Vector2:
	# My old attempt
	#var random_y_coord = randi_range(0, ground_center.y)
	#var fortegn = [-random_y_coord, +random_y_coord]
	#var y_coord_plus_or_minus = fortegn[randi_range(0,1)]
	#var calculated_x_coord = ground_center.x + y_coord_plus_or_minus*2
	#var spawn_point_vector = Vector2(calculated_x_coord, random_y_coord)
	var random_angle = randi_range(1,359)
	var x_coord = ground_center.x + radius * cos(random_angle)
	var y_coord = ground_center.y + radius * sin(random_angle)
	var spawn_point_vector = Vector2(x_coord, y_coord)
	return spawn_point_vector


func _on_spawntimer_timeout() -> void:
	spawn_comet()
	spawntimer.wait_time = randf_range(0.1,0.9)
	spawntimer.start()
