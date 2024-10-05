extends Node
class_name StateTracker

const SaveData = preload("res://scripts/res_recipes/save_data.gd")
const save_data_path = "user://save_data.tres"

var game_time : int = 0

signal points_changed
var points : int = 0:
	get:
		#print("Points accessed %d" %points)
		return points
	set(amount): 
		points = amount
		points_changed.emit(points)

signal health_changed
var health : int = 3:
	get:
		#print("health was acessed %d" % health)
		return health
	set(value):
		health = value
		health_changed.emit(health)				


func save_to_file(points, file_path) -> void: 
	var save_file
	if not FileAccess.file_exists(file_path):
		save_file = SaveData.new() 
		save_file.all_scores.append(points)
	else:
		save_file = ResourceLoader.load(file_path)
	ResourceSaver.save(save_file, file_path)
		#FileAccess.open(file_path, FileAccess.WRITE)
	#else: 
		#save_file = FileAccess.open(file_path, FileAccess.READ)
	#save_file.all_scores.append(points)
	#FileAccess.open(file_path, FileAccess.WRITE)
		
	
	
func load_from_file() -> void: 
	pass


signal game_over
func end_game() -> void: 
	print("You earned ", GameState.points, " points!")
	print("You survived for: ", GameState.game_time)
	#save_to_file(GameState.points, save_data_path)
	game_over.emit()
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()




func _ready() -> void:
	start_game_time()
	save_to_file(points, save_data_path)


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
