extends Node2D
class_name CometSpawner


const COMET = preload("res://scenes/comet_basic.tscn")
const STAR = preload("res://scenes/shooting_star.tscn")

@onready var random_spawn_position_component: RandomSpawnPositionComponent = $RandomSpawnPositionComponent
@onready var spawntimer: Timer = $Spawntimer


@export var radius : int = 1600

var ground_center : Vector2


func _ready() -> void:
	ground_center = Vector2.ZERO
	spawntimer.start()
	
	
	
func _process(delta: float) -> void:
	pass
	
## TESTING: Comet spawn on 'Enter' key
func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("ui_accept"):
			spawn_celestial(COMET, true)
##
	
func spawn_celestial(scene : PackedScene, is_burning : bool = false) -> void:
	var new_object = scene.instantiate()
	new_object.SPAWN_POINT = random_spawn_position_component.random_spawn_position(ground_center, radius)
	new_object.speed_multiplier = Difficulty.comet_speed(GameState.intensity)
	
	if new_object.name == "CometBasic":
		if randf() < Difficulty.burn_chance(GameState.intensity) or is_burning:
			new_object.modulate = Color.DIM_GRAY
			new_object.extra_waiting_time = randf_range(1.5,5.0)
	get_parent().add_child(new_object)

func random_spawn_position() -> Vector2:
	var random_angle = randi_range(1,359)
	var x_coord = ground_center.x + radius * cos(random_angle)
	var y_coord = ground_center.y + radius * sin(random_angle)
	var spawn_point_vector = Vector2(x_coord, y_coord)
	return spawn_point_vector


func _on_spawntimer_timeout() -> void:
	var new_object = choose_random_celestial()
	spawn_celestial(new_object)
	spawntimer.wait_time = Difficulty.spawn_interval(GameState.intensity)
	spawntimer.start()


func choose_random_celestial() -> PackedScene:
	var random_num = randi_range(1,10)
	if random_num < 2:
		return STAR
	else:
		return COMET 
		
