extends Node
class_name StateTracker


var game_time : int = 0


signal game_over
func end_game() -> void: 
	print("You earned ", GameState.points, " points!")
	print("You survived for: ", GameState.game_time)
	# Here it should generate total score
	# and save to user://
	clear()
	game_over.emit()
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()


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
		health_changed.emit()				


func _ready() -> void:
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
	#print(game_time)

func clear() -> void: 
	points = 0
	game_time = 0 
