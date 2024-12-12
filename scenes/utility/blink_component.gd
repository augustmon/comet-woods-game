class_name BlinkComponent
extends Node

@export var entity : Node2D

func blink_yellow() -> void: 
	var tween = create_tween()
	tween.tween_property(entity, "modulate", Color.YELLOW, 0.3)
	tween.tween_property(entity, "modulate", Color.WHITE, 0.1)

func blink_red() -> void:
	var red_tween = create_tween()
	red_tween.tween_property(entity, "modulate", Color.RED, 0.1)
	red_tween.tween_property(entity, "modulate", Color.WHITE, 0.5)
