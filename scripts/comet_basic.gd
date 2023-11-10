extends CelestialObject
class_name CometBasic


@onready var smoke_trail: CPUParticles2D = $SmokeTrail
@onready var firetail: Node2D = $Firetail


func deal_damage() -> void:
	pass

func grounded_animations() -> void: 
	smoke_trail.emitting = false
	#polygon_2d.visible = false
	
