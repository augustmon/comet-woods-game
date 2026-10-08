extends Node2D

@onready var message_label: Label = $Control/VBoxContainer/MessageLabel
@onready var scores_label: Label = $Control/VBoxContainer/ScoresLabel
@onready var start_button : Button = $Control/ButtomContainer/StartButton

const WORLD : PackedScene = preload("res://scenes/world.tscn")

func _ready(): 
	GameState.high_scores = GameState.load_from_file(GameState.save_data_path)
	GameState.high_scores.sort_custom(func(a, b): return a.points > b.points)
	var top_five = GameState.high_scores.slice(0,5)
	scores_label.text = "" 
	var current_score_in_top_five : bool = false 
	for score in top_five:
		if GameState.current_score:
			if (score.points == GameState.current_score.points and score.time == GameState.current_score.time):
				scores_label.text += "Your score: -->"
				current_score_in_top_five = true
		scores_label.text += str(score.points, " POINTS ---- ", score.time, " SECONDS")
		scores_label.text += "\n"
	if GameState.current_score: 
		if not current_score_in_top_five:
			message_label.text = "Sorry, you did not make the top 5...."
		elif current_score_in_top_five:
			message_label.text = "Good Job dodging those comets!!!! "
			
	
	
func _on_start_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(WORLD)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameState.flush_data()
