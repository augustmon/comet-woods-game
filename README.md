# Comet Woods

A small browser game: stand on a spinning planet in an autumn forest at night and dodge falling comets. Catch the shooting stars for points. The type is projectile avoidance.
The game was earlier called "Project Zero". Names considered: Comet Forest, Comet Run, Rolling Comets, Meteor Madness.

**Vibe:** hectic, chaotic, aesthetic, autumn
**Art references:** *Night in the Woods*, *Over the Garden Wall*, cutout art
**Scope:** a hobby project. **Engine:** Godot 4.7, Compatibility renderer

## Controls

| Action | Keys |
|---|---|
| Rotate world | A / D, ← / → |
| Jump | Space, W, ↑ |
| Crouch | ↓ |
| Debug: restart / die | R / . |

## Definition of done

1. **v1.0:** runs in the browser (Web export) and saves the player's own top scores in the browser.
2. **Complete:** a shared online leaderboard backed by a BaaS (backend-as-a-service).
3. **Always:** keep the download small and the game smooth in the browser.

## Roadmap

### Now: fix the basics
- [x] Fix score saving. Scores are never written to disk, and the first launch crashes.
- [x] Remove the start-screen key that wipes all scores.
- [x] Fix the jump buffer and short jump.
- [x] Make crouch a dodge/slide. Right now crouching stops the world from rotating, which is a bug.
- [x] Finish the player state machine refactor, then merge it.

### v1.0: browser release
- [x] Upgrade to Godot 4.7
- [x] Add a Web export preset (single-threaded)
- [ ] Host the game (itch.io or GitHub Pages)
- [x] Save scores in the browser. Godot stores `user://` in IndexedDB; tested in a release web build.
- [ ] Add a win/lose screen
- [ ] Add sound effects: run, world rotation, comet impact, star catch
- [ ] Add music that builds in intensity, matched to the difficulty curve
- [ ] Difficulty scaling (spawn rate ✅). Still to do: comet speed, longer ground time, comets that target the player.
- [ ] Populate the world (moon ✅, grass ✅). Still to do: trees and bushes, leaves blowing when the world rotates.

### Size & performance
- [ ] Commit `assets/` (only about 5 MB) and stop committing builds in `exports/` (about 56 MB)
- [ ] Shrink the textures (about 400 KB each): smaller sizes, WebP/lossy compression, atlases
- [ ] Load fonts only for the glyphs the game uses
- [x] Remove the debug console (Panku). It crashed release web builds.
- [ ] Try a custom export template with unused engine modules turned off (3D, physics extras)
- [ ] Profile in the browser: particle counts, shaders, lights

### Complete
- [ ] Online leaderboard on a BaaS (e.g. Supabase, Firebase)

## Project layout

```
scenes/                 scenes and scene scripts
  state_switcher/       player state machine (idle, run, jump, fall, crouch)
scripts/
  game_state.gd         autoload: points, health, time, saving scores
  components/           reusable rotation and spawn-position components
  handlers/             jump input
assets/                 art, fonts, textures
```
