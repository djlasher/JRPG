# Persistent engineering instructions

This repository is **Lanterns of Larkspur**, a Godot 4.7.2 top-down JRPG written only in GDScript. Milestone 2 explicitly introduced turn-based combat; extend it through the documented data and controller-first interfaces rather than adding action combat.

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

## Adventure architecture

- `AdventureMap` parameterizes the Lanternvale Reach, Brackenford, Mosswick, Echoing Grotto, Stillpick Mine, and Floodroot Hollow. Add destinations through `setup()`, bounded collision, an obvious return doorway, distinctive landmarks, treasure, and curated encounters.
- `EnemyDatabase` owns enemy stats, rewards, AI profile, visual identity, formation membership, and boss status. `BattleUI` owns turn flow and reports results to `Main`; commands are Attack, Skills, Items, Defend, and Flee. Bosses disallow fleeing.
- The damage baseline is `max(1, attack - defense / 2 + random(-2,2))`. Skills apply their multiplier before defense. Combatants are array records so later party members need not redesign formations.
- Durable stats are in `GameState`; `stat()` applies Weapon, Armor, and Accessory modifiers. Inns restore HP/MP. `GameState.SKILLS` and item effect fields are the content extension points.
- `GameState.QUESTS` defines quests. Runtime records contain `status` and `progress`; states are Available (absence), Active, Ready, and Completed. `track(type,target,amount)` is the objective-progress entry point. Guild boards accept and turn in town-specific jobs.
- Supported objective vocabulary is `visit`, `interact`, `collect`, `defeat_specific`, and general `defeat`. New quests require giver, category, target/count, and reward.
- Treasure IDs, boss IDs, and world-event IDs are stable persistence keys. Never rename shipped IDs without migration. Boss definitions set `boss=true` and defeated persistent bosses must not respawn.
- Save version 2 persists equipment, stats, progression, quests, treasure, bosses, events, and scene/map ID while supplying defaults for version 1 saves.

## Milestone 3 conventions

- Save version 3 adds party, party state, bestiary, discoveries, fast travel, puzzle state, and guild reputation. Continue must remove the title `CanvasLayer` before restoring a world or only higher-layer HUD elements will be visible.
- `GameState.PARTY_DEFS` owns identity, role, color, and skills. `party_state` owns runtime member stats. `party` is the ordered roster and `recruit()` is idempotent.
- `CombatMath` is the sole damage-formula source. Physical damage is `max(1, attack - floor(defense × 0.35) + variance)`. Never duplicate formulas in UI/AI; battle feedback must show damage and remaining HP.
- Bestiary records use stable enemy IDs and seen/defeated counts. Call `discover_enemy()` on encounter and victory.
- `MapWidget.LOCATIONS` and `_geography()` are map-ID-specific. Compact mode is the live minimap; full mode labels journal markers. Every new destination requires an accurate marker/geography entry.
- Discovery and travel IDs match `AdventureMap.setup()`. UI emits `travel_requested`; `Main` owns transitions and clears pause state.
- Permanent puzzles use stable keys in `puzzle_states`. Lumenport has its own city renderer; never represent major cities through the generic settlement renderer.

## Milestone 4 architecture

- Save version 4 persists jobs, job levels/JP, learned/cross-job skills, relationships/events/romance, story branches, vehicles, ship state/upgrades, and known planets. Migrations from versions 1–3 remain mandatory.
- `GameState.JOBS` is the job database. Character level never changes during `change_job()`. `job_state[character]` owns current job, per-job levels/JP, permanently learned skills, and limited equipped inheritance slots. Character baseline × job modifier + equipment is the stat order.
- Job points are awarded independently after battle by `gain_job_points()`. Jobs cap at level 10. Advanced/secret jobs carry clues and must enter `unlocked_jobs` only through authored conditions.
- Relationship keys are canonical `left:right` pairs. Every romance-capable record must explicitly set `adult=true`. Early bond events change points; only an explicit commitment action sets `romance=true`. Event IDs prevent replay.
- Major story branches live in `story_branches`, never incidental dialogue flags. Branch choices may reconverge but consequences must read the explicit branch value.
- `vehicles` owns unlocks/current mode. Road, boat, aircraft, and spacecraft are recognizable `Player.appearance_mode` silhouettes. Vehicle collision continues to use map collision; future terrain masks should specialize it rather than bypassing collision.
- `AdventureMap` is also the cross-world router. `space` is a manually piloted map; planet/Hell IDs are local surfaces and return through `return_space`. Do not process off-world maps when they are not current.
- `ShipBattleUI` is distinct from character battle. Ship damage uses `CombatMath`, shields absorb before hull, and hull defeat never overwrites a valid save. Ship state lives in `GameState.ship`.
- Map hierarchy is surface region → local area, or space → planet/Hell local area. `MapWidget` requires explicit entries for every cross-world ID.

## Milestone 5 architecture

- Save version 5 persists Resonance Marks, activated Advancement Lattice nodes, deterministic generated equipment, and chest-roll IDs. Older saves receive the expanded seven-slot equipment layout without losing equipped legacy gear.
- `ProgressionDatabase` owns the 120-node lattice, eight spell schools, equipment bases, rarity tiers, affixes, and named legendary pool. Keep generated item identity stable by seeding rolls from persistent chest IDs.
- Lattice activation must be adjacent to an active node and spend character-specific Resonance Marks. Learned spell IDs are copied into the character's permanent learned list for battle/menu use.
- Generated gear records contain an instance ID, base ID, rarity, slot, rating, stats, affixes, and description. Equipment comparisons must use `GameState.item_data()` so legacy and generated gear share one path.
- Equipment slots are Weapon, Head, Body, Hands, Feet, Accessory1, and Accessory2. Avoid reintroducing generic Armor/Accessory slots except in backward migrations.
- Treasure remains deterministic and persistent: a shipped chest ID may never silently change its seed or reward identity.

## Visual atlas architecture

- Generated raster art lives under `assets/generated/`; runtime region mappings belong in `VisualAssets`. Never scatter raw atlas coordinates through gameplay scripts.
- Enemy IDs remain the durable contract for quests, saves, formations, and bestiary records. Visual substitutions should update `VisualAssets.MONSTERS`, not rename shipped enemy IDs.
- `VisualAssets` supplies `AtlasTexture` icons for UI and source regions for custom `_draw()` code. Preserve transparent padding and use aspect-preserving scaling for portraits.
- The current atlas is intentionally text-free. Names and stats remain native Godot controls for localization, focus, accessibility, and save compatibility.
- `master_pixel_atlas.png` is the broad world/character source sheet; `PixelAssets` owns its regions. It supplies exploration characters, NPCs, terrain, architecture, interiors, and vehicles. `dark_fantasy_atlas.png` remains the focused portrait/item atlas through `VisualAssets`.
- Preserve both master sources unchanged. When a region needs cleanup, add a derived sibling asset instead of overwriting either supplied atlas.

## Battle playability

- Root battle commands are Attack, Skills, Magic, Items, Defend, and Flee. Skills, spells, and consumables must always open controller-focusable selection menus; B returns to the root commands.
- Ordinary enemy damage is deliberately forgiving enough to support exploration and testing. Bosses may hit harder, but defend and carried healing must remain meaningful and victories provide modest HP/MP recovery.
- Battle portraits communicate action: player hits flash the target, enemy attacks lunge, and party damage triggers a brief red overlay. Preserve feedback when adding effects rather than reverting combat to text-only updates.
- Visible encounters roam gently around stable origins. They do not chase yet, and interaction checks must use their live positions.
- Pause navigation is hierarchical: B returns from any journal submenu to the Travel Journal root, and B at the root closes it. Menu/Start always closes the entire journal; reopening always reconstructs the root rather than retaining submenu state.

