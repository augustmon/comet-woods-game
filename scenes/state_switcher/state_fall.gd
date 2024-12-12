class_name FallState
extends State


func _activate(): 
	set_physics_process(true)
	fsm.animator.play("fall")

func _deactivate(): 
	set_physics_process(false)
