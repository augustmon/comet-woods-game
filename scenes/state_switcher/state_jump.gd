class_name JumpState
extends State

signal to_fall_state

# StateSwitcher is set automatically

func _activate():
	set_physics_process(true)
	fsm.actor.jump_input_handler.jump()

func _deactivate():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	fsm.actor.jump_input_handler.cut_jump()
	fsm.actor.jump_input_handler.buffer_jump()

	if fsm.actor.velocity.y > 0:
		to_fall_state.emit()
