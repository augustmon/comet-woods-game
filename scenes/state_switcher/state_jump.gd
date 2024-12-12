class_name JumpState
extends State

@onready var delay_timer: Timer = $"../../DelayTimer"

var jump_buffer : bool = false 

signal hit_floor

# StateSwitcher set automatically
func _ready() -> void: 
	super._ready()
	set_physics_process(false)
	delay_timer.timeout.connect(_on_delay_timer_timeout)
	
func _on_delay_timer_timeout() -> void:
	jump_buffer = false
	
	
func _activate(): 
	set_physics_process(true)

func _deactivate(): 
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	fsm.actor.velocity.y = fsm.actor.JUMP_VELOCITY
	fsm.actor.animation_player.play("jump")
	
	if Input.is_action_just_released("jump") and fsm.actor.velocity.y < fsm.actor.JUMP_VELOCITY / 2:
		fsm.actor.velocity.y = fsm.actor.JUMP_VELOCITY / 2
	elif Input.is_action_just_released("jump") and fsm.actor.velocity.y > 0:
		jump_buffer = true
		delay_timer.start() 
		
	if fsm.actor.is_on_floor(): 
		hit_floor.emit()
		
