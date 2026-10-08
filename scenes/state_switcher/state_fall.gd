class_name FallState
extends State

signal to_idle_state

func _activate():
	set_physics_process(true)
	fsm.animator.play("fall")

func _deactivate():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	fsm.actor.jump_input_handler.buffer_jump()

	if fsm.actor.is_on_floor():
		to_idle_state.emit()
