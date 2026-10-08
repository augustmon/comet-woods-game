extends Node2D

@onready var message_label: Label = $Control/VBoxContainer/MessageLabel
@onready var scores_label: Label = $Control/VBoxContainer/ScoresLabel
@onready var start_button : Button = $Control/ButtomContainer/StartButton

const WORLD : PackedScene = preload("res://scenes/world.tscn")

func _ready(): 
	scores_label.text = "" 
	for score in GameState.load_scores():
		if score == GameState.current_score:
			scores_label.text += "Your score: -->"
		scores_label.text += str(score.points, " POINTS ---- ", score.time, " SECONDS")
		scores_label.text += "\n"
	if GameState.current_score: 
		if GameState.current_score_is_top:
			message_label.text = "Good Job dodging those comets!!!! "
		else:
			message_label.text = "Sorry, you did not make the top 5...."
			
	
func _on_start_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(WORLD)
