class_name IdleState
extends State

	
func _activate(): 
	set_physics_process(true)
	fsm.animator.play("idle")

func _deactivate(): 
	set_physics_process(false)
