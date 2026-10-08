class_name State extends Node

@export var fsm : StateSwitcher

func _ready() -> void: 
	set_physics_process(false)
	fsm = get_parent()

func _activate() -> void: 
	set_physics_process(true)
	print("Entering ", self.name)
	
func _deactivate(): 
	set_physics_process(false)
	print("Exiting ", self.name)
	
	
