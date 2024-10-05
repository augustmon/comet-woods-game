extends Sprite2D

const GRASS_1 = preload("res://assets/deco/grass_1.png")
const GRASS_2 = preload("res://assets/deco/grass_2.png")

func _ready() -> void:
	var random_texture = randi_range(1,2)
	if random_texture == 1:
		texture = GRASS_1
	elif random_texture == 2:
		texture = GRASS_2
