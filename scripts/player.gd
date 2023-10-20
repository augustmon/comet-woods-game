extends CharacterBody2D
class_name Player

var JUMP_HEIGHT : float = 800.0
@export var GRAVITY : float = 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var state = State
enum State {
	RUNNING, 
	STANDING,
	JUMPING
}



func _process(delta: float) -> void:
	
	# Jump mechanics
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_HEIGHT
		print("jump!", velocity)
		
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		State.RUNNING
		modulate = Color.WHEAT
		animation_player.current_animation = "run"
	else: 
		state = State.STANDING
		modulate = Color.WHITE
		animation_player.current_animation = "idle"
		
	apply_gravity()
	move_and_slide()


func apply_gravity() -> void:
	velocity.y += GRAVITY
