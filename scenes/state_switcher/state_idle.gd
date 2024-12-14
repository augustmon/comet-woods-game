class_name IdleState
extends State

signal to_run_state
signal to_jump_state
	
func _activate(): 
	set_physics_process(true)
	fsm.animator.play("idle")

func _deactivate(): 
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	fsm.animator.play("idle")
	
	if Input.get_axis("move_left", "move_right") != 0:
		to_run_state.emit()
		
	if fsm.actor.jump_input_handler.is_pressed_jump():
		to_jump_state.emit()
	#
	#if Input.is_action_just_pressed("jump") or (state_jump.jump_buffer and Input.is_action_pressed("jump")):
		#to_jump_state.emit()
		#
