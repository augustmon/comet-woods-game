extends Node
class_name StateTracker


var game_time = 0

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


func clear() -> void: 
	points = 0
	game_time = 0 
