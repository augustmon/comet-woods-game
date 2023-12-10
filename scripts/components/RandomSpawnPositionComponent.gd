class_name RandomSpawnPositionComponent extends Node

@export var radius_object : Node2D


func random_spawn_position(center : Vector2, radius : int) -> Vector2:
	var random_angle = randi_range(1,359)
	var x_coord = center.x + radius * cos(random_angle)
	var y_coord = center.y + radius * sin(random_angle)
	var spawn_point_vector = Vector2(x_coord, y_coord)
	return spawn_point_vector
