class_name DeathExplosion extends GPUParticles2D

@onready var collision_shape_2d: CollisionShape2D = $CometVanish/HitArea/CollisionShape2D
@onready var hit_area: HitArea = $CometVanish/HitArea

func _ready() -> void:
	collision_shape_2d.scale = scale
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(func(): 
		hit_area.queue_free())
	

func _on_hit_area_area_entered(area: Area2D) -> void:
	var name_of_object = area.get_parent().name
	if name_of_object == "Player":
		GameState.health -= 1
