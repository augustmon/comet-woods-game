extends Label

@onready var ground: StaticBody2D = $"../../Ground"

func _process(delta: float) -> void:
	text = str(ground.rotation_speed)
