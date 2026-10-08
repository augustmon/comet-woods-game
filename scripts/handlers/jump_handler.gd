class_name JumpInputHandler
extends Node2D


@export var player : Player

@onready var jump_buffer_timer: Timer = $JumpBufferTimer

# Jump pressed shortly before landing - jump as soon as player hits the ground
var jump_buffer : bool = false


func _ready() -> void:
	jump_buffer_timer.timeout.connect(func(): jump_buffer = false)

func is_pressed_jump() -> bool:
	return Input.is_action_just_pressed("jump") or (jump_buffer and Input.is_action_pressed("jump"))

func jump() -> void:
	jump_buffer = false
	jump_buffer_timer.stop()
	player.velocity.y = player.JUMP_VELOCITY
	player.animation_player.play("jump")

# Shorten jumps - release button quickly for shorter jump
func cut_jump() -> void:
	if Input.is_action_just_released("jump") and player.velocity.y < player.JUMP_VELOCITY / 2:
		player.velocity.y = player.JUMP_VELOCITY / 2

# Call while airborne
func buffer_jump() -> void:
	if Input.is_action_just_pressed("jump") and not player.is_on_floor():
		jump_buffer = true
		jump_buffer_timer.start()
