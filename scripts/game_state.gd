extends Node
class_name StateTracker

signal points_changed
var points : int = 0:
	get:
		#print("Points accessed %d" %points)
		return points
	set(amount): 
		points = amount
		points_changed.emit(points)
		
var game_time = 0


func clear() -> void: 
	points = 0
	game_time = 0 
