extends StaticBody2D

@export var MAX_ROTATION_SPEED : float = 1
@export var FRICTION : float = 0.1
@export var SPEED_RAMP : float = 1.1
@export var rotation_speed : float = 0


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left") and abs(rotation_speed) < MAX_ROTATION_SPEED:
		rotation_speed += 1
	if Input.is_action_pressed("move_right") and abs(rotation_speed) < MAX_ROTATION_SPEED:
		rotation_speed -= 1
	#
	apply_friction()
	rotation += rotation_speed*delta
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		var tree = get_tree()
		tree.reload_current_scene()
	
func apply_friction() -> void: 
	## OLD METHOD, WHERE THE FLOOR ALWAYS ROTATES A BIT...
	#if sign(rotation_speed) == -1:
		#rotation_speed += FRICTION
	#elif sign(rotation_speed) == 1:
		#rotation_speed -= FRICTION
	#else: 
		#pass
	rotation_speed = move_toward(rotation_speed, 0, FRICTION)


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass
