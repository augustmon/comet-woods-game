extends CharacterBody2D
class_name Player

@export var JUMP_VELOCITY : float = -500.0
@export var GRAVITY : float = 1400.0
@export var MAX_HEALTH : int = 3

var grounded_position : float
var jump_buffer : bool = false 


@onready var player_sprites: Sprite2D = $PlayerSprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var delay_timer: Timer = $DelayTimer

enum State {
	RUNNING, 
	STANDING,
	JUMPING
}
@export var state : State = State.STANDING


func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_move_animations()
	move_and_slide()

	handle_flip_direction()
	
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func take_damage(damage_amount) -> void:
	GameState.health -= damage_amount
	var red_tween = create_tween()
	red_tween.tween_property(self, "modulate", Color.RED, 0.5)
	if GameState.health <= 0:
		GameState.end_game()
		


func handle_jump() -> void: 
	if is_on_floor():
		if Input.is_action_just_pressed("jump") or (jump_buffer and Input.is_action_pressed("jump")):
			state = State.JUMPING
			velocity.y = JUMP_VELOCITY
			
	elif Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	
	elif Input.is_action_just_released("jump") and velocity.y > 0:
		jump_buffer = true
		delay_timer.start() 
		
	if not is_on_floor() and State.JUMPING:
		animation_player.current_animation = "jump"			
		

func handle_flip_direction() -> void:
	if Input.is_action_just_pressed("move_left"):
		player_sprites.scale.x = 1
	if Input.is_action_just_pressed("move_right"):
		player_sprites.scale.x = -1
		
func handle_move_animations():
	if is_on_floor():
		if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			state = State.RUNNING
			animation_player.current_animation = "run"
		else: 
			state = State.STANDING
			animation_player.current_animation = "idle"

func determine_grounded_position() -> void:
	if is_on_floor() and not grounded_position:
		grounded_position = position.y


func _on_hit_box_area_entered(area: Area2D) -> void:
	var hitting_object = area.get_parent()
	if hitting_object.has_method("give_point"):
		GameState.points += 1
	elif hitting_object.has_method("deal_damage"):
		take_damage(1)
	area.get_parent().queue_free()
	
	
func _on_delay_timer_timeout() -> void:
	jump_buffer = false

	
