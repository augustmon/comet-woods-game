class_name Difficulty extends RefCounted
## All difficulty curves, as functions of GameState.intensity (1.0 per minute
## of play, no upper limit). Difficulty keeps rising until the game is impossible.

# Seconds between spawns: starts around BASE, then shrinks towards 0
const BASE_SPAWN_INTERVAL : float = 0.5
const SPAWN_RATE_GROWTH : float = 0.35 # spawn rate +35% per minute
const SPAWN_INTERVAL_JITTER : float = 0.8 # +-80% randomness

# Comet speed multiplier: +60% per minute
const SPEED_GROWTH : float = 0.6

# Chance a comet burns (stays on the ground): rises towards MAX
const MAX_BURN_CHANCE : float = 0.6
const BURN_CHANCE_GROWTH : float = 0.35


static func spawn_interval(intensity: float) -> float:
	var mean = BASE_SPAWN_INTERVAL / (1.0 + SPAWN_RATE_GROWTH * intensity)
	return mean * randf_range(1.0 - SPAWN_INTERVAL_JITTER, 1.0 + SPAWN_INTERVAL_JITTER)


static func comet_speed(intensity: float) -> float:
	return 1.0 + SPEED_GROWTH * intensity


static func burn_chance(intensity: float) -> float:
	return MAX_BURN_CHANCE * (1.0 - exp(-BURN_CHANCE_GROWTH * intensity))
