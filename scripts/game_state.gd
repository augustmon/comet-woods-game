extends Node
class_name PointTracker

signal points_changed
var points : int = 0:
	get:
		print("Points accessed %d" %points)
		return points
	set(amount): 
		points = amount
		points_changed.emit(points)
		
