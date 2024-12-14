class_name StateSwitcher extends Node

@onready var actor: Player = $".."
@onready var animator: AnimationPlayer = $"../AnimationPlayer"

@export var current_state: State

# STATES
@onready var state_idle: IdleState = $IdleState
@onready var state_jump: JumpState = $State_Jump
@onready var state_run: RunState = $RunState
@onready var state_fall: FallState = $FallState

func bind_state_signals() -> void: 
	state_idle.to_run_state.connect(set_state.bind(state_run))
	state_idle.to_jump_state.connect(set_state.bind(state_jump))
	state_run.to_idle_state.connect(set_state.bind(state_idle))
	state_run.to_jump_state.connect(set_state.bind(state_jump))

func _ready() -> void:
	set_state(current_state)
	bind_state_signals()
	#state_jump.hit_floor.connect(_on_hit_floor)

func set_state(new_state: State) -> void:
	if current_state is State: 
		current_state._deactivate() 
	current_state = new_state
	current_state._activate() 

func _process(delta) -> void:
	print(current_state)
# Determine states
#func _process(delta: float) -> void:
	#if actor.is_on_floor():
		## JUMP STATE 
		##if Input.is_action_just_pressed("jump") or (state_jump.jump_buffer and Input.is_action_pressed("jump")):
			##set_state(state_jump)
	## 	# RUN STATE
		##elif Input.get_axis("move_left", "move_right"):
			##set_state(state_run)
		## IDLE STATE
#
		#set_state(state_idle)
	## FALL STATE
	#elif not actor.is_on_floor() and actor.velocity.y > 0:
		#set_state(state_fall)
			
