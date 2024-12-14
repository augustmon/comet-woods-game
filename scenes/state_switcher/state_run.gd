class_name RunState
extends State

signal to_idle_state
signal to_jump_state

func _activate(): 
	set_physics_process(true)
	fsm.animator.play("run")

func _deactivate(): 
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	if Input.get_axis("move_left", "move_right"):
		fsm.animator.play("run")
	
	if fsm.actor.jump_input_handler.is_pressed_jump():
		to_jump_state.emit()
	
	elif Input.get_axis("move_left", "move_right") == 0 and fsm.actor.is_on_floor():
		to_idle_state.emit()
		
