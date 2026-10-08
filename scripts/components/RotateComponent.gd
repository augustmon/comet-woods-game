class_name RotateComponent extends Node

const WORLD_ROTATION_GROUP = "world_rotation"

@export var actor = Node2D

@export var MAX_ROTATION_SPEED : float = 2
@export var FRICTION : float = 10
@export var SLIDE_FRICTION : float = 2
@export var ACC : float = 10
@export var rotation_speed : float = 0

# Coasting ignores input and slows down with SLIDE_FRICTION (player sliding)
var coasting : bool = false

func _ready() -> void:
	add_to_group(WORLD_ROTATION_GROUP)

func set_coasting(value: bool) -> void:
	coasting = value

func rotate_from_input(delta) -> void:
	var input_direction = 0.0 if coasting else Input.get_axis("move_right", "move_left")
	if input_direction < 0 and rotation_speed > -MAX_ROTATION_SPEED:
		rotation_speed = move_toward(rotation_speed, -MAX_ROTATION_SPEED, ACC*delta)
	elif input_direction > 0 and rotation_speed < MAX_ROTATION_SPEED:
		rotation_speed = move_toward(rotation_speed, MAX_ROTATION_SPEED, ACC*delta)
	else:
		apply_friction(delta)
	actor.rotation += rotation_speed * delta


func apply_friction(delta: float) -> void:
	var friction = SLIDE_FRICTION if coasting else FRICTION
	rotation_speed = move_toward(rotation_speed, 0, delta * friction)
