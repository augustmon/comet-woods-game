class_name SkyRotator extends Node2D


#@export var current_rotation_speed : float = 0
#@export var sky_movement_data : SkyMovementData 

var darkness : float = 0.0
var sky_colour : Color = Color(0.0, 0.0, 1.0, 0.0)
var darkening : bool = true

@onready var sky_background: MeshInstance2D = $SkyBackground
@onready var sky_texture: Sprite2D = $SkyTexture
@onready var moon: Sprite2D = $Moon
@onready var point_light_2d: PointLight2D = $Moon/PointLight2D
@onready var rotate_component: RotateComponent = $RotateComponent as RotateComponent

func _ready() -> void:
	#GameState.time_increased.connect(_on_time_increased)
	pass

	
func _process(delta: float) -> void:
	#if Input.is_action_pressed("move_left") and abs(current_rotation_speed) < sky_movement_data.max_rotation_speed:
		#current_rotation_speed += sky_movement_data.acc
	#if Input.is_action_pressed("move_right") and abs(current_rotation_speed) < sky_movement_data.max_rotation_speed:
		#current_rotation_speed -= sky_movement_data.acc
	##
	#apply_friction(delta)
	#rotation += current_rotation_speed*delta
	
	rotate_component.rotate_from_input(delta)

	add_moonlight()
	increase_colour_alpha(delta, sky_colour)


	
#func apply_friction(delta) -> void: 
	#current_rotation_speed = move_toward(current_rotation_speed, 0.0, sky_movement_data.friction * delta)

func increase_colour_alpha(delta : float, colour : Color) -> void: 	
	determine_darkening()	
	change_darkness(delta)
	apply_sky_colour()
	
func change_darkness(delta) -> void:
	if darkening:			
		darkness = move_toward(darkness, 0.9, 0.01*delta) 
	elif not darkening: 
		darkness = move_toward(darkness, 0.0, 0.01*delta)
	
func determine_darkening() -> void: 
	if darkness >= 0.9:
		darkening = not darkening 
		if not sky_colour:
			sky_colour = get_random_colour()
	elif darkness <= 0: 
		darkening = not darkening
		var new_colour = get_random_colour()
		sky_colour = new_colour	
			
func get_random_colour() -> Color: 
	var new_random_colour = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),darkness) 
	return new_random_colour
	
		
func apply_sky_colour() -> void: 
	sky_colour.a = darkness
	sky_texture.modulate = sky_colour

	
func add_moonlight() -> void: 
	var game_time_float = GameState.game_time/2000.0
	if point_light_2d.scale.x <= 2.0:
		var time_scale : Vector2 = Vector2(moon.scale.x + game_time_float, moon.scale.y + game_time_float)
		point_light_2d.scale = time_scale
	if game_time_float < 0.95:
		moon.modulate = Color(1.0, 1.0, 1.0, game_time_float)
