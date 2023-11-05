extends Node2D
class_name SkyRotator

@export var current_rotation_speed : float = 0
@export var sky_movement_data : SkyMovementData 

var darkness : float = 0.0

@onready var sky_texture: Sprite2D = $SkyTexture

func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left") and abs(current_rotation_speed) < sky_movement_data.max_rotation_speed:
		current_rotation_speed -= sky_movement_data.acc
	if Input.is_action_pressed("move_right") and abs(current_rotation_speed) < sky_movement_data.max_rotation_speed:
		current_rotation_speed += sky_movement_data.acc
	#
	apply_friction(delta)
	rotation += current_rotation_speed*delta
	add_darkness()
	
func apply_friction(delta) -> void: 
	current_rotation_speed = move_toward(current_rotation_speed, 0.05, sky_movement_data.friction * delta)

func add_darkness() -> void: 
	darkness += 0.0001
	sky_texture.modulate = Color(0,0,0.4,darkness)
