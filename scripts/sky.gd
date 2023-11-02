extends Node2D
class_name SkyRotator

@export var MAX_ROTATION_SPEED : float = 1
@export var FRICTION : float = 10.0
@export var SPEED_RAMP : float = 0.2
@export var rotation_speed : float = 0


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left") and abs(rotation_speed) < MAX_ROTATION_SPEED:
		rotation_speed -= SPEED_RAMP
	if Input.is_action_pressed("move_right") and abs(rotation_speed) < MAX_ROTATION_SPEED:
		rotation_speed += SPEED_RAMP
	#
	apply_friction(delta)
	rotation += rotation_speed*delta
	
func apply_friction(delta) -> void: 
	rotation_speed = move_toward(rotation_speed, 0.05, FRICTION * delta)
