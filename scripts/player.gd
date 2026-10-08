class_name Player
extends CharacterBody2D

@export var JUMP_VELOCITY : float = -500.0
@export var GRAVITY : float = 1400.0
@export var MAX_HEALTH : int = 3
@export var jump_input_handler : JumpInputHandler

var grounded_position : float

@onready var blink_component: BlinkComponent = $BlinkComponent
@onready var player_sprites: Sprite2D = $PlayerSprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skid_particles: CPUParticles2D = $SkidParticles
@onready var fsm: StateSwitcher = $StateSwitcher

func _ready() -> void:
	GameState.points_changed.connect(_on_points_changed)
	GameState.health_changed.connect(_on_health_changed)

func _on_points_changed(points) -> void:
	if points > 0:
		blink_component.blink_yellow() 
	
func _on_health_changed(health) -> void: 
	if health < 3: 
		blink_component.blink_red()
		determine_game_over(health) 
	
func determine_game_over(health) -> void:
	if health <= 0:
		GameState.end_game()
	

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()
	handle_flip_direction()
	if GameState.health_cooldown == true:
		GameState.decrease_health_cooldown()
	
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta


func handle_flip_direction() -> void:
	if Input.is_action_just_pressed("move_left"):
		player_sprites.scale.x = -1
	if Input.is_action_just_pressed("move_right"):
		player_sprites.scale.x = 1
		

func determine_grounded_position() -> void:
	if is_on_floor() and not grounded_position:
		grounded_position = position.y
#


	
