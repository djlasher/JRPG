# Persistent engineering instructions

This repository is **Lanterns of Larkspur**, a Godot 4.7.2 top-down JRPG written only in GDScript. Combat is outside the current product scope: never add enemies, battles, combat statistics, leveling, or attack controls unless explicitly requested.

## Architecture

- `scenes/` contains thin, composable scene entry points. Use PascalCase node names and snake_case `.tscn` filenames.
- `scripts/core/` owns globally relevant flow. `GameState` and `SaveManager` are the only autoloads. Do not make feature-specific objects autoloads.
- `scripts/characters/`, `scripts/npc/`, `scripts/world/`, and `scripts/ui/` contain reusable runtime classes. Script filenames are snake_case; globally named GDScript classes are PascalCase.
- World content is described as dictionaries/data and instantiated by reusable classes. Keep future item, NPC, dialogue, and shop content separate from player control logic.
- Rendering uses an original low-resolution vector/pixel-inspired visual language. Preserve the 640×360 internal canvas and readable controller-first UI.

## Systems

- `Player` reads named input actions, remembers facing, and exposes no content-specific interaction logic.
- A map implements `try_interact()` and emits `interaction_requested(kind, payload)`. `Main` routes requests to the corresponding UI or transition. Add new interactables through this contract.
- `NPCActor` owns route-following, pauses, collision, facing presentation, and conversation pausing. NPC definitions provide name, dialogue pages, color, speed, and optional waypoint route.
- Dialogue is page-oriented data passed to `GameUI.dialogue()`. Do not bury conversation text in movement code or use placeholder dialogue.
- Shops refer to item IDs from `GameState.ITEMS`; purchasing must go through `GameState.buy()` so money and inventory stay consistent.
- Saves are versioned JSON at `user://larkspur_save.json`. Save data must remain backward-aware and corrupt/missing files must fail safely. All durable state belongs in `GameState.serialize()` / `restore()`.
- Exterior/interior travel is owned by `Main` and uses a fade. Door-specific scripts must not duplicate transition logic.
- Xbox is primary: left stick/D-pad move, A confirms/interacts, B cancels, Menu pauses. Keep keyboard fallback and use actions rather than raw button checks.

## Collision layers

1. World geometry and furniture
2. Player
3. Reserved for future non-interactive actors
4. NPC/interactable bodies

Keep doorways at least 48 pixels wide and avoid routes that can pin the player against static geometry.

## Validation

Before completing a change, run a Godot 4.7.2 headless import and a short project launch, inspect output for parser/resource errors, verify `run/main_scene`, input actions, focus defaults, paths, transitions, save/load, purchases, and controller navigation. Manually test relevant acceptance steps in the editor. Prefer reusable systems over town-specific hacks.
