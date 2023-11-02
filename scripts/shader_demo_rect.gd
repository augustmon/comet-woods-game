extends ColorRect

@onready var shader_material : ShaderMaterial = self.material

var changing_value : float = 0.0

func _ready() -> void: 
	shader_material.set_shader_parameter("red", 0.1)
	
func _process(delta) -> void: 
	#var new_value = randf_range(0.0,0.9)
	#changing_value = move_toward(changing_value, new_value, 0.01)
	#shader_material.set_shader_parameter("red", changing_value)
	pass
