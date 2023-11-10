extends Node2D
class_name CometSpawner

#TODO Essentials:
# # 2. Introduce Game Timer to increase flying speed and spawn frequency 
# # 4. Start 

const COMET = preload("res://scenes/comet_basic.tscn")
const STAR = preload("res://scenes/shooting_star.tscn")

@onready var spawntimer: Timer = $Spawntimer
var ground_center : Vector2

@export var radius : int = 1600

var chance_of_comet_burning : int = 0



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
	var new_object = scene.instantiate()
	new_object.SPAWN_POINT = random_spawn_position()
	new_object.speed_multiplier = 1 + GameState.game_time/1000
	
	if new_object.name == "CometBasic":
		determine_chance_of_comet_burning()
		if randi_range(0,100) < chance_of_comet_burning:
			new_object.extra_waiting_time = randf_range(1.0,5.0)
	get_parent().add_child(new_object)
	
func determine_chance_of_comet_burning() -> void: 
	if GameState.game_time > 60:
		chance_of_comet_burning = 50
	if GameState.game_time > 30: 
		chance_of_comet_burning = 20
	if GameState.game_time > 10:
		chance_of_comet_burning = 10
	
func random_spawn_position() -> Vector2:
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
		
