class_name RunState
extends State

signal to_idle_state
signal to_jump_state
signal to_crouch_state

var running_time = 0

func _activate():
	running_time = 0
	set_physics_process(true)
	fsm.animator.play("run")

func _deactivate():
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if fsm.actor.is_on_floor():
		if fsm.actor.jump_input_handler.is_pressed_jump():
			to_jump_state.emit()

		elif Input.is_action_pressed("down"):
			to_crouch_state.emit()

		elif Input.get_axis("move_left", "move_right") == 0:
			to_idle_state.emit()
			if running_time > 2.0:
				fsm.actor.skid_particles.emit()

		else:
			fsm.animator.play("run", -1, 1.5)

	running_time += 5*delta
