class_name RunState
extends State

func _activate(): 
	set_physics_process(true)
	fsm.animator.play("run")

func _deactivate(): 
	set_physics_process(false)
	
	
func _physics_process(delta: float) -> void:
	if Input.get_axis("move_left", "move_right"):
		fsm.animator.play("run")
