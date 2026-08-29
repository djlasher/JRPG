# Lanterns of Larkspur

An original controller-first 2D top-down JRPG vertical slice. Ari arrives in Larkspur, a river town whose old waylights guide travelers through the valley fog. This milestone contains exploration and town life—no combat.

## Requirements and launch

Use **Godot 4.7.2 stable**. Open `project.godot` and press F6/F5 (Run Project). The configured main scene is `scenes/main.tscn`; no plugins, downloads, or runtime network access are required.

## Controls

| Action | Xbox controller | Keyboard |
|---|---|---|
| Move / menu | Left stick or D-pad | WASD or arrows |
| Interact / confirm | A | E, Space, or Enter |
| Cancel | B | Escape |
| Travel journal / pause | Menu | Escape |

## Current slice

- Title screen with New Game, save-aware Continue, and Quit
- Large camera-bounded town with market, square, fountain, church quarter, nature, south gate, and distinctive waylight save point
- Ten enterable locations: two shops, inn, church, archive, and five furnished homes
- Nineteen named residents across exterior and interiors; six follow looping waypoint routes and pause naturally
- Multi-page dialogue, reusable facing interaction, controller focus, and pause/status/inventory journal
- Functional general and equipment shops, persistent currency and inventory, and fee-based inn rest
- Versioned JSON save/load of location, position, currency, inventory, flags, and play time
- Collision on map boundaries, buildings, water, trees, counters, walls, and furniture
- Fade-based reusable exterior/interior transitions and a guarded not-yet-available town exit

## Layout and architecture

- `scenes/` – project entry scenes
- `scripts/core/` – game flow, durable state, and saving
- `scripts/characters/` – player controller
- `scripts/npc/` – reusable NPC actor and waypoint motion
- `scripts/world/` – town and parameterized interior maps
- `scripts/ui/` – dialogue, shop, inn, and journal presentation
- `docs/` – implementation and test report

`GameState` is the authoritative inventory/currency/location model. `SaveManager` serializes it to `user://larkspur_save.json`. Maps expose a small interaction signal contract; `Main` owns transitions and UI routing. Content definitions remain independent of player movement.

## Save behavior

Interact with the glowing Waylight east of the fountain, choose Save, then return to the title screen. Continue is enabled only when a save exists. Missing or malformed saves are rejected without crashing. Save version 1 is intentionally explicit for future migrations.

## Known limitations

- The milestone has no combat by design.
- Purchased items are view-only until a future item-use system is requested.
- Audio is intentionally silent rather than shipping low-quality generated music.
- Runtime validation in the authoring environment used Godot 4.6.3 because 4.7.2 was unavailable; final editor playthrough should use 4.7.2.

## Suggested next milestones

Add a second outdoor map, richer directional animation and repository sprites, item-use hooks, dialogue conditions/flags, audio buses with original music, and accessibility options. Add combat only as a separate explicitly authorized milestone.
