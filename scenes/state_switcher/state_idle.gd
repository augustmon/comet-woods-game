class_name IdleState
extends State

signal to_run_state
signal to_jump_state
signal to_crouch_state

func _activate():
	set_physics_process(true)
	fsm.animator.play("idle")

func _deactivate():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if fsm.actor.is_on_floor():
		if fsm.actor.jump_input_handler.is_pressed_jump():
			to_jump_state.emit()

		elif Input.is_action_pressed("down"):
			to_crouch_state.emit()

		elif Input.get_axis("move_left", "move_right") != 0:
			to_run_state.emit()
