extends Node
class_name StateTracker

const SaveData = preload("res://scripts/res_recipes/save_data.gd")
const save_data_path = "user://save_data.tres" # On web, user:// is stored in the browser (IndexedDB)
const MAX_SCORES : int = 5

var game_time : int = 0

# Use to show players own score.
var current_score : Dictionary = {}
var current_score_is_top : bool = false
var game_ended : bool = false

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
	

# Adds score to the saved top list. Returns true if it made the list.
func save_score(score: Dictionary) -> bool: 
	var scores = load_scores()
	scores.append(score)
	scores.sort_custom(func(a, b): return a.points > b.points)
	scores = scores.slice(0, MAX_SCORES)
	write_scores(scores)
	return score in scores

# Highest first. Empty if no save file or the file is unreadable.
func load_scores() -> Array: 
	if not FileAccess.file_exists(save_data_path):
		return []
	var save_file = ResourceLoader.load(save_data_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if not save_file is SaveData:
		push_warning("Save file unreadable, starting with no scores")
		return []
	return save_file.all_scores.duplicate()

func write_scores(scores: Array) -> void: 
	var save_file = SaveData.new()
	save_file.all_scores = scores
	var error = ResourceSaver.save(save_file, save_data_path)
	if error != OK:
		push_error("Could not save scores: ", error_string(error))

# Debug: call from the Panku console with GameState.clear_scores()
func clear_scores() -> void: 
	write_scores([])


signal game_over
func end_game() -> void: 
	if game_ended: # Several hits in one frame can end the game twice
		return
	game_ended = true
	current_score = {"points": points, "time": game_time}
	current_score_is_top = save_score(current_score)
	game_over.emit()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	


func _ready() -> void:
	start_game_time()


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
	game_ended = false
	game_time = 0 
	points = 0
	health = 3 
