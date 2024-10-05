extends Node2D


func _ready() -> void: 
	GameState.game_over.connect(_on_game_over)
	GameState.clear()
	
	
func _on_game_over() -> void:
	modulate = Color.RED

	
func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("restart"):
			var tree = get_tree()
			tree.reload_current_scene()
		if event.is_action_pressed("die"):
			GameState.end_game()
