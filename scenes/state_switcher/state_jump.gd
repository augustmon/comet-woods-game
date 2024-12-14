class_name JumpState
extends State

signal to_idle_state
signal to_fall_state

# StateSwitcher is set automatically
	
func _activate(): 
	set_physics_process(true)
	fsm.actor.jump_input_handler.handle_jumping()
#
func _deactivate(): 
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	fsm.actor.jump_input_handler.handle_jumping()
	
	if fsm.actor.velocity.y > 0: 
		to_fall_state.emit()
	
	# TODO Move to fall state
	if fsm.actor.is_on_floor(): 
		to_idle_state.emit()
		
