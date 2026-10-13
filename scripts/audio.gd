extends Node
## Autoload "Audio": layered music that follows GameState.intensity, and sound effects.
## Intensity rises without limit (1.0 per minute), so music changes level off.

#region MUSIC
# Stems play in sync. Each fades in gradually over its intensity range [from, to].
const MUSIC_STEMS = [
	preload("res://assets/audio/music/main/pad.wav"),
	preload("res://assets/audio/music/main/bass.wav"),
	preload("res://assets/audio/music/main/drums.wav"),
	preload("res://assets/audio/music/main/lead.wav"),
]
const LAYER_FADE_RANGES = [Vector2(0, 0), Vector2(0, 0), Vector2(0.3, 1.0), Vector2(1.0, 2.0)]
const LAYER_FADE_SPEED : float = 40.0 # dB per second, smooths sudden jumps
const SILENT_DB : float = -60.0
# Music speeds up towards MAX_MUSIC_SPEED but never reaches it
const MAX_MUSIC_SPEED : float = 1.15
const MUSIC_SPEED_GROWTH : float = 0.35
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


func layer_target_db(layer: int, intensity: float) -> float:
	var fade_range : Vector2 = LAYER_FADE_RANGES[layer]
	var amount = 1.0 if intensity >= fade_range.y else smoothstep(fade_range.x, fade_range.y, intensity)
	return maxf(linear_to_db(amount), SILENT_DB)


func music_speed(intensity: float) -> float:
	return 1.0 + (MAX_MUSIC_SPEED - 1.0) * (1.0 - exp(-MUSIC_SPEED_GROWTH * intensity))


func _process(delta: float) -> void:
	var intensity = GameState.intensity
	for i in layer_volumes.size():
		var target = layer_target_db(i, intensity)
		if layer_volumes[i] != target:
			layer_volumes[i] = move_toward(layer_volumes[i], target, LAYER_FADE_SPEED * delta)
			music.set_sync_stream_volume(i, layer_volumes[i])
	music_player.pitch_scale = music_speed(intensity)


func _on_points_changed(points: int) -> void:
	if points > last_points:
		play_sfx("star_catch")
	last_points = points


func _on_health_changed(health: int) -> void:
	if health < last_health:
		play_sfx("hit")
	last_health = health


func _input(event: InputEvent) -> void:
	# Debug: I skips one minute ahead (+1 intensity) to test music and difficulty
	if OS.is_debug_build() and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_I:
		GameState.play_time += 60.0
		print("Intensity: ", snappedf(GameState.intensity, 0.01))
