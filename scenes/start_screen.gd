extends Node2D


@onready var scores_label: Label = $Control/ScoresLabel
@onready var start_button : Button = $Control/ButtomContainer/StartButton

const WORLD : PackedScene = preload("res://scenes/world.tscn")

func _ready(): 
	scores_label.text = "HEY"
	GameState.load_from_file(GameState.save_data_path)
	GameState.high_scores.sort_custom(func(a, b): return a.points > b.points)
	scores_label.text = "" 
	for score in GameState.high_scores:
		scores_label.text += str(score.points, " POINTS ---- ", score.time, " SECONDS")
		scores_label.text += "\n"
	
	
func _on_start_button_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(WORLD)
