class_name Ground extends StaticBody2D

@onready var rotate_component: RotateComponent = $RotateComponent
@onready var random_spawn_position_component: RandomSpawnPositionComponent = $RandomSpawnPositionComponent as RandomSpawnPositionComponent
const GRASS = preload("res://scenes/grass.tscn")

func _ready() -> void:
	for i in range(32):
		var new_grass = GRASS.instantiate()
		new_grass.z_index = randi_range(0,1)
		new_grass.position = random_spawn_position_component.random_spawn_position(Vector2.ZERO, 600)
		if new_grass.z_index == 0:
			new_grass.show_behind_parent = true
		var angle_to_center = new_grass.get_angle_to(Vector2.ZERO)
		new_grass.rotate(angle_to_center - 1.55)
	
		add_child(new_grass)
	
	
func _process(delta: float) -> void:
	rotate_component.rotate_from_input(delta)
	

