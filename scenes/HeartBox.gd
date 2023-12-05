class_name HeartBox extends HBoxContainer



func _ready() -> void:
	GameState.health_changed.connect(_on_health_changed)
	for i in range(GameState.health):
		var heart = get_child(i)
		heart.visible = true
	
func _on_health_changed(health) -> void: 
	print(get_children())
	if get_children():
		for heart in get_children():
			heart.visible = false
		for i in range(health):
			var heart = get_child(i)
			print(heart)
			heart.visible = true
		
