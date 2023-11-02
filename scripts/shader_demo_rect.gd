extends ColorRect

@onready var shader_material : ShaderMaterial = self.material

var changing_value : float = 0.0

func _ready() -> void: 
	shader_material.set_shader_parameter("red", 0.1)
