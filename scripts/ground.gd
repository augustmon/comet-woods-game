extends StaticBody2D
class_name Ground


@export var MAX_ROTATION_SPEED : float = 1
@export var FRICTION : float = 0.1
@export var ACC : float = 0.2
@export var rotation_speed : float = 0


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left") and abs(rotation_speed) < MAX_ROTATION_SPEED:
		rotation_speed += ACC
	if Input.is_action_pressed("move_right") and abs(rotation_speed) < MAX_ROTATION_SPEED:
		rotation_speed -= ACC	#
	if not Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		apply_friction()
	rotation += rotation_speed*delta
	
	
func apply_friction() -> void: 
	rotation_speed = move_toward(rotation_speed, 0, FRICTION)


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass
