class_name RotateComponent extends Node


@export var actor = Node2D

@export var MAX_ROTATION_SPEED : float = 2
@export var FRICTION : float = 10
@export var ACC : float = 10
@export var rotation_speed : float = 0

func rotate_from_input(delta) -> void: 
	var input_direction = Input.get_axis("move_right", "move_left")
	if input_direction < 0 and rotation_speed > -MAX_ROTATION_SPEED:
		rotation_speed = move_toward(rotation_speed, -MAX_ROTATION_SPEED, ACC*delta)
	elif input_direction > 0 and rotation_speed < MAX_ROTATION_SPEED:
		rotation_speed = move_toward(rotation_speed, MAX_ROTATION_SPEED, ACC*delta)
	else:
		apply_friction(delta)
	actor.rotation += rotation_speed * delta
	
	
func apply_friction(delta: float) -> void: 
	rotation_speed = move_toward(rotation_speed, 0, delta * FRICTION)
