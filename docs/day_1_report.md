# Day 1 vertical-slice report

## Built

The repository now boots into **Lanterns of Larkspur**, presents a controller-navigable title screen, and supports a complete no-combat town loop: exploration, conversations, waypoint residents, ten interiors, shopping, inventory/currency, paid inn rest, church worldbuilding, pause/status UI, saving/loading, and a gated south-road exit.

The town has an original brass-lantern identity, readable color-coded buildings, market and residential districts, a fountain landmark, river/water boundary, trees and flowers, furnished interiors, and nineteen named residents. Dialogue establishes local texture without committing the hero to a large backstory.

## Decisions

- Thin entry scene; runtime classes compose the world rather than one monolithic `.tscn`.
- Only durable global concerns are autoloads.
- Interaction is a map-level signal contract and never a list of object types in `Player`.
- Ten building interiors share a parameterized layout class but populate context-specific hosts, furniture, and interactions.
- Route motion is opt-in NPC data and pauses during conversation.
- Versioned JSON keeps saves inspectable and migration-friendly.

Read `scripts/core/main.gd`, `scripts/core/game_state.gd`, `scripts/world/town.gd`, `scripts/world/interior.gd`, and `scripts/ui/game_ui.gd` first. `AGENTS.md` is the persistent convention source.

## Compromises and validation

The installed command-line engine is Godot 4.6.3, not 4.7.2. A headless editor import found and resolved the initial parser issue. A full headless play launch was blocked by the sandbox denying Godot's `user://logs` directory, and the engine crashed while handling that denial. No external assets or missing paths are required.

The deliberately compact art is drawn from reusable Godot primitives rather than copied or downloaded assets. It is cohesive and original, but richer sprite-sheet animation would be a natural visual polish milestone. Audio is silent by choice.

## Manual Godot 4.7.2 checklist

1. Open `project.godot`, run, and confirm title focus and save-aware Continue.
2. Start a game; test stick, D-pad, WASD, A/E/Enter/Space, B/Escape, and Menu.
3. Walk into building/tree/water boundaries and confirm collision.
4. Talk through multiple pages; interrupt each of the six moving route NPCs and confirm they resume.
5. Enter and leave all ten buildings and verify doorway placement.
6. Buy from both shops; verify insufficient-funds feedback and inventory/currency changes.
7. Accept and decline the inn offer; verify the 24-crown deduction.
8. Read the church altar, fountain, and south-road messages.
9. Save at the Waylight; inspect pause status/items, quit to title, Continue, and verify restored state.
10. Resize/fullscreen the window and verify the 640×360 presentation scales cleanly.

## Recommended next work

Perform the 4.7.2 editor checklist, add automated GDScript smoke tests, replace primitive character poses with an original directional sprite sheet, add subtle original UI sounds and town ambience, and build the first connected road map. Do not introduce combat without explicit authorization.
