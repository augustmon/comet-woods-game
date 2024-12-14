class_name JumpInputHandler
extends Node2D


@export var player : Player 

@onready var jump_buffer_timer: Timer = $JumpBufferTimer

var jump_buffer : bool = false 


func _ready() -> void: 
	jump_buffer_timer.timeout.connect(func(): jump_buffer = false) 
	
func is_pressed_jump() -> bool:
	if Input.is_action_just_pressed("jump") or (jump_buffer and Input.is_action_pressed("jump")):
		return true
	else:
		return false

func handle_jumping() -> void: 
	player.velocity.y = player.JUMP_VELOCITY
	player.animation_player.play("jump")
	# Shorten jumps - release button quickly for shorter jump
	if Input.is_action_just_released("jump") and player.velocity.y < player.JUMP_VELOCITY / 2:
		player.velocity.y = player.JUMP_VELOCITY / 2
	
	# Coyote jumps - possible to release jump button before hit ground
	elif Input.is_action_just_released("jump") and player.velocity.y > 0:
		jump_buffer = true
		jump_buffer_timer.start() 
