extends Node
class_name StateTracker

const SaveData = preload("res://scripts/res_recipes/save_data.gd") # Makes an instance of save_data object
const save_data_path = "user://save_data.tres" # Instance of SaveData resource 

var high_scores : Array

var game_time : int = 0

signal points_changed
var points : int = 0:
	get:
		return points
	set(amount): 
		points = amount
		points_changed.emit(points)

signal health_changed
var health : int = 3:
	get:
		return health
	set(value):
		health = value
		health_changed.emit(health)				

var health_cooldown : bool = false

func decrease_health_cooldown(): 
	if health_cooldown == true:
		await get_tree().create_timer(1).timeout
		health_cooldown = false
	

func save_to_file(points_total, file_path) -> void: 
	var save_file
	if not FileAccess.file_exists(file_path):
		save_file = SaveData.new() 
	else:
		save_file = ResourceLoader.load(file_path)
		if not "all_scores" in save_file: 
			save_file = SaveData.new() 
			save_file.all_scores = [] 
	save_file.all_scores.append({"points": points_total, "time": game_time})
	ResourceSaver.save(save_file, file_path)

	
func load_from_file(file_path) -> void: 
	if FileAccess.file_exists(file_path):
		var load_file = ResourceLoader.load(file_path)
		if not "all_scores" in load_file: 
			load_file = SaveData.new() 
		high_scores = load_file.all_scores
	else:
		var load_file = "NO DATA"
			

func flush_data(): 
	if FileAccess.file_exists(save_data_path):
		var save_data = FileAccess.open(save_data_path, FileAccess.WRITE)
		save_data = [] 
		print("Resource file deleted")
	else:
		print("Resource file not found")


signal game_over
func end_game() -> void: 
	print("You earned ", points, " points!")
	print("You survived for: ", game_time)
	save_to_file(points, save_data_path)
	game_over.emit()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	#get_tree().reload_current_scene()


func _ready() -> void:
	start_game_time()
	#save_to_file(points, save_data_path)


func start_game_time() -> void:
	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_timer_timout)
	get_tree().get_root().add_child.call_deferred(timer)	

func _on_timer_timout():
	increment_time()

signal time_increased
func increment_time():
	game_time += 1
	time_increased.emit()

func clear() -> void: 
	game_time = 0 
	points = 0
	health = 3 
