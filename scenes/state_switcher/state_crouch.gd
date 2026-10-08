class_name CrouchState
extends State

# Crouch from idle = duck. Crouch from run = slide: world coasts with the
# speed it had, no steering, until released or stopped.

signal to_idle_state
signal to_jump_state

func _activate():
	set_physics_process(true)
	fsm.animator.play("crouch")
	get_tree().call_group(RotateComponent.WORLD_ROTATION_GROUP, "set_coasting", true)

func _deactivate():
	set_physics_process(false)
	get_tree().call_group(RotateComponent.WORLD_ROTATION_GROUP, "set_coasting", false)

func _physics_process(delta: float) -> void:
	if fsm.actor.is_on_floor() and fsm.actor.jump_input_handler.is_pressed_jump():
		to_jump_state.emit()
	elif not Input.is_action_pressed("down"):
		to_idle_state.emit()
