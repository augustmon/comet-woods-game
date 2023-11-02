extends CharacterBody2D
class_name Player

@export var JUMP_VELOCITY = -400.0
@export var GRAVITY : float = 1200.0
@export var MAX_HEALTH : int = 3

var grounded_position : float
var jump_buffer : bool = false 

signal health_changed
var HEALTH : int = MAX_HEALTH:
	get:
		#print("health was acessed %d" % HEALTH)
		return HEALTH
	set(value):
		HEALTH = value
		health_changed.emit()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var delay_timer: Timer = $DelayTimer

enum State {
	RUNNING, 
	STANDING,
	JUMPING
}
@export var state = State


func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_move_animations()
	move_and_slide()
	count_seconds(delta)
	
func count_seconds(delta) -> void: 
	GameState.game_time += delta
	

func _format_seconds(time : float, use_milliseconds : bool = true) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func take_damage(damage_amount) -> void:
	HEALTH -= damage_amount
	animation_player.current_animation = "hurt"
	if HEALTH <= 0:
		game_over()
		
func game_over() -> void: 
	var formatted_time = _format_seconds(GameState.game_time)
	print("You earned ", GameState.points, " points!")
	print("You survived for: ", formatted_time)
	# Here it should generate total score
	# and save to user://
	GameState.clear()
	get_parent().modulate = Color.RED
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

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
		
func handle_move_animations():
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state = State.RUNNING
		if animation_player.current_animation != "hurt":
			animation_player.current_animation = "run"
	else: 
		state = State.STANDING
		if animation_player.current_animation != "hurt":
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

	
