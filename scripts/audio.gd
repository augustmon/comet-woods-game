extends Node
## Autoload "Audio": layered music that follows GameState.intensity, and sound effects.

#region MUSIC
# Stems play in sync. Each fades in once intensity reaches its threshold.
const MUSIC_STEMS = [
	preload("res://assets/audio/music/main/pad.wav"),
	preload("res://assets/audio/music/main/bass.wav"),
	preload("res://assets/audio/music/main/drums.wav"),
	preload("res://assets/audio/music/main/lead.wav"),
]
const LAYER_THRESHOLDS = [0.0, 0.0, 0.25, 0.5]
const LAYER_FADE_SPEED : float = 40.0 # dB per second
const SILENT_DB : float = -60.0
const MAX_MUSIC_SPEED : float = 1.12 # pitch_scale at full intensity
#endregion

#region SFX
const SFX = {
	"jump": preload("res://assets/audio/sfx/jump.wav"),
	"star_catch": preload("res://assets/audio/sfx/star_catch.wav"),
	"impact": preload("res://assets/audio/sfx/impact.wav"),
	"hit": preload("res://assets/audio/sfx/hit.wav"),
	"game_over": preload("res://assets/audio/sfx/game_over.wav"),
}
const SFX_POLYPHONY : int = 6
const SFX_RANDOM_PITCH : float = 1.05
#endregion

var music_player : AudioStreamPlayer
var music : AudioStreamSynchronized
var layer_volumes : Array[float] = []
var sfx_players : Dictionary = {}

# Debug: press I to step through intensities, overriding GameState.intensity
const DEBUG_INTENSITIES = [-1.0, 0.0, 0.25, 0.5, 1.0]
var debug_intensity_index : int = 0

var last_points : int = 0
var last_health : int = 0


func _ready() -> void:
	setup_music()
	setup_sfx()
	last_points = GameState.points
	last_health = GameState.health
	GameState.points_changed.connect(_on_points_changed)
	GameState.health_changed.connect(_on_health_changed)
	GameState.game_over.connect(play_sfx.bind("game_over"))


func setup_music() -> void:
	music = AudioStreamSynchronized.new()
	music.stream_count = MUSIC_STEMS.size()
	for i in MUSIC_STEMS.size():
		music.set_sync_stream(i, MUSIC_STEMS[i])
		music.set_sync_stream_volume(i, SILENT_DB)
		layer_volumes.append(SILENT_DB)
	music_player = AudioStreamPlayer.new()
	music_player.stream = music
	music_player.bus = &"Music"
	# Web exports default to sample playback, which can't play synchronized streams
	music_player.playback_type = AudioServer.PLAYBACK_TYPE_STREAM
	add_child(music_player)
	music_player.play()


func setup_sfx() -> void:
	for sfx_name in SFX:
		var randomizer = AudioStreamRandomizer.new()
		randomizer.add_stream(-1, SFX[sfx_name])
		randomizer.random_pitch = SFX_RANDOM_PITCH
		var player = AudioStreamPlayer.new()
		player.stream = randomizer
		player.bus = &"SFX"
		player.max_polyphony = SFX_POLYPHONY
		add_child(player)
		sfx_players[sfx_name] = player


func play_sfx(sfx_name: String) -> void:
	sfx_players[sfx_name].play()


func current_intensity() -> float:
	var debug_intensity = DEBUG_INTENSITIES[debug_intensity_index]
	return debug_intensity if debug_intensity >= 0.0 else GameState.intensity


func _process(delta: float) -> void:
	var intensity = current_intensity()
	for i in layer_volumes.size():
		var target = 0.0 if intensity >= LAYER_THRESHOLDS[i] else SILENT_DB
		if layer_volumes[i] != target:
			layer_volumes[i] = move_toward(layer_volumes[i], target, LAYER_FADE_SPEED * delta)
			music.set_sync_stream_volume(i, layer_volumes[i])
	music_player.pitch_scale = lerpf(1.0, MAX_MUSIC_SPEED, intensity)


func _on_points_changed(points: int) -> void:
	if points > last_points:
		play_sfx("star_catch")
	last_points = points


func _on_health_changed(health: int) -> void:
	if health < last_health:
		play_sfx("hit")
	last_health = health


func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_I:
		debug_intensity_index = (debug_intensity_index + 1) % DEBUG_INTENSITIES.size()
		print("Music intensity override: ", DEBUG_INTENSITIES[debug_intensity_index])
