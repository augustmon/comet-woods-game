extends Node2D
class_name CometSpawner

#TODO Essentials:
# # 1. Refactor Comet class to generic "Celestials" 
# # 2. Introduce Game Timer to increase flying speed and spawn frequency 
# # 3. Implement Star scenes and points counter (Keep in GameState?)
# # 4. Start screen

const COMET = preload("res://scenes/comet_basic.tscn")
const STAR = preload("res://scenes/shooting_star.tscn")

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
		spawn_celestial(COMET)
##
	
func spawn_celestial(scene : PackedScene) -> void:
	var new_comet = scene.instantiate()
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
	var new_object = choose_random_celestial()
	spawn_celestial(new_object)
	spawntimer.wait_time = randf_range(0.1,0.9)
	spawntimer.start()


func choose_random_celestial() -> PackedScene:
	var random_num = randi_range(1,10)
	if random_num < 2:
		return STAR
	else:
		return COMET 
		
