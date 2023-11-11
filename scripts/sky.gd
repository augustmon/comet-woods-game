extends Node2D
class_name SkyRotator

@export var current_rotation_speed : float = 0
@export var sky_movement_data : SkyMovementData 

var darkness : float = 0.0

@onready var sky_texture: Sprite2D = $SkyTexture
@onready var moon: Sprite2D = $Moon

func _ready() -> void:
	#GameState.time_increased.connect(_on_time_increased)
	pass

	
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left") and abs(current_rotation_speed) < sky_movement_data.max_rotation_speed:
		current_rotation_speed -= sky_movement_data.acc
	if Input.is_action_pressed("move_right") and abs(current_rotation_speed) < sky_movement_data.max_rotation_speed:
		current_rotation_speed += sky_movement_data.acc
	#
	apply_friction(delta)
	rotation += current_rotation_speed*delta
	add_darkness(Color(0.0, 0.0, 0.4, darkness))
	
func apply_friction(delta) -> void: 
	current_rotation_speed = move_toward(current_rotation_speed, 0.05, sky_movement_data.friction * delta)

#func _on_time_increased() -> void:
	#if darkness < 0.9:
		#add_darkness(Color(0,0,0.4,darkness))

#TODO: keep changing colour over time 
func add_darkness(colour : Color) -> void: 
	var game_time_float = GameState.game_time/200000.0
	darkness += game_time_float
	sky_texture.modulate = colour
	moon.modulate = Color(1.0, 1.0, 1.0, darkness)
