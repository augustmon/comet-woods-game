class_name StateSwitcher extends Node

@onready var actor: Player = $".."
@onready var animator: AnimationPlayer = $"../AnimationPlayer"

@export var current_state: State
#region STATES
@onready var idle_state: IdleState = $IdleState
@onready var jump_state: JumpState = $JumpState
@onready var run_state: RunState = $RunState
@onready var fall_state: FallState = $FallState
@onready var crouch_state: CrouchState = $CrouchState

#region

func bind_state_signals() -> void: 
	idle_state.to_run_state.connect(set_state.bind(run_state))
	idle_state.to_jump_state.connect(set_state.bind(jump_state))
	idle_state.to_crouch_state.connect(set_state.bind(crouch_state))
	run_state.to_idle_state.connect(set_state.bind(idle_state))
	run_state.to_jump_state.connect(set_state.bind(jump_state))
	run_state.to_crouch_state.connect(set_state.bind(crouch_state))
	jump_state.to_fall_state.connect(set_state.bind(fall_state))
	fall_state.to_idle_state.connect(set_state.bind(idle_state))
	crouch_state.to_idle_state.connect(set_state.bind(idle_state))
	crouch_state.to_jump_state.connect(set_state.bind(jump_state))


func _ready() -> void:
	set_state(current_state)
	bind_state_signals()

func set_state(new_state: State) -> void:
	if current_state is State: 
		current_state._deactivate() 
	current_state = new_state
	current_state._activate() 
