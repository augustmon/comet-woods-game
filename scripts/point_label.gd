extends Label


func _ready() -> void:
	text = str(GameState.points)
	GameState.points_changed.connect(_on_points_changed)

func _on_points_changed(points : int):
	text = str(points)
