extends StaticBody2D
class_name Ground


#@export var MAX_ROTATION_SPEED : float = 2
#@export var FRICTION : float = 10
#@export var ACC : float = 10
#@export var rotation_speed : float = 0

@onready var rotate_component: RotateComponent = $RotateComponent


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	rotate_component.rotate_from_input(delta)
	

