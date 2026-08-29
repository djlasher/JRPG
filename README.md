# Lanterns of Larkspur

An original controller-first 2D top-down JRPG adventure. Ari leaves the river town of Larkspur for the broad Lanternvale Reach: settlements, caves, guild work, persistent treasure, visible monsters, and classic turn-based battles.

## Launch and controls

Use **Godot 4.7.2 stable**. Open `project.godot` and Run Project. No plugins, downloads, paid assets, or runtime network access are required.

| Action | Xbox controller | Keyboard |
|---|---|---|
| Move / navigate | Left stick or D-pad | WASD or arrows |
| Interact / confirm | A | E, Space, Enter |
| Cancel | B | Escape |
| Travel journal | Menu | Escape |
| Battle choice | D-pad and A/B | Arrows and Enter/Escape |

## Current adventure

- Complete original Larkspur town with eleven enterable buildings, including its new Wayfarers' Guild
- 2600×1900 Lanternvale Reach with roads, river boundaries, woodland, rocky uplands, landmarks, hidden branches, and deterministic discoveries
- Brackenford and Mosswick settlements, each with outfitter, inn, Waylight, and guild board
- Echoing Grotto, Stillpick Mine, and optional Floodroot Hollow dungeon maps
- Eleven original enemy types, visible encounters, mixed formations, rare Glass Fox, and two persistent bosses
- Turn combat with Attack, Skill, Item, Defend, and Flee; HP/MP, EXP, levels, rewards, defeat behavior, and boss restrictions
- Twelve data-driven main, side, and guild quests with persistent objective progress and controller quest log
- Functional Weapon, Armor, and Accessory equipment with calculated stat modifiers
- Persistent regional/dungeon treasure and ten authored world discoveries

## Architecture

- `scripts/core/` — flow, versioned game state, saving
- `scripts/world/` — original town/interiors and parameterized adventure destinations
- `scripts/combat/` — enemy definitions/formations and battle presentation/turns
- `scripts/ui/` — dialogue, shops, inn, equipment, quest log, guild boards, journal
- `scripts/characters/`, `scripts/npc/` — reusable exploration actors
- `docs/` — milestone reports and playtest routes

`GameState` is authoritative for inventory, equipment, stats, quests, progression, and persistent world state. `EnemyDatabase` defines combat content, `BattleUI` runs turns, and `AdventureMap` creates the region and destination maps. All maps retain the common interaction signal contract; `Main` owns transitions and routing.

## Save behavior

Waylights write versioned JSON to `user://larkspur_save.json`. Version 2 records map/position, currency, inventory, HP/MP, level/EXP, equipment, quests, treasures, bosses, and events. Version 1 town saves receive safe defaults. Missing or malformed saves fail gracefully.

## Known limitations

- Ari is the only playable party member, though battles use formation/combatant arrays.
- The Skills command currently executes the starter Lantern Cut directly rather than opening a larger skill submenu.
- Settlements and dungeons share a parameterized renderer rather than bespoke scene files.
- Audio remains intentionally silent.
- Authoring validation used Godot 4.6.3 because 4.7.2 was unavailable locally.

See `docs/day_2_report.md` for the content inventory, validation notes, and recommended playtest route.

## Seven Lamps chapter additions

- Recruitable party: Ari, shield captain Brann, and tide scholar Lyra Vale
- Lumenport major city, Sunstep Abbey, Tideglass Aqueduct, and Fallen Observatory
- Party status, bestiary, accurate per-area maps, live minimap, and Waylight fast travel
- Save version 3 persists party, bestiary, discoveries, fast travel, puzzles, and guild reputation while migrating versions 1–2

See `docs/day_3_report.md` for stabilization details and the current chapter limitations.

## Beyond the world

Milestone 4 foundations add separate character/job progression, eight foundational and five advanced/secret vocations, persistent adult relationship/romance choices, an explicit story branch, progressive ground/boat/air/space vehicles, controllable space travel, turn-based ship combat, Viridia, Cyr Ember, Orison Moon, and the peaceful demon city of Cinder Court. Save format 4 retains these systems across Continue.

See `docs/day_4_report.md` for the implementation boundary and playtest route.

## Resonance and relics

Milestone 5 adds a controller-driven 120-node Advancement Lattice, Resonance Marks earned in battle, eight schools of magic with sixteen authored spells, and deterministic equipment drops. Gear now uses seven visible slots and five rarity tiers, including a pool of named Myth-Circuit legendaries. The Equipment screen compares rating and stat changes before equipping, and save format 5 retains lattice choices and generated items while migrating earlier saves.

See `docs/day_5_report.md` for the system inventory, validation record, and remaining presentation work.

## Dark-fantasy visual pass

A generated transparent atlas now replaces primitive placeholders for visible exploration enemies, battle portraits, treasure chests, spell entries, and equipment rows. Enemy gameplay IDs remain unchanged so quests, formations, bestiary progress, and existing saves continue to work. See `docs/asset_gap_report.md` for the next-sheet inventory and ready-to-paste generation briefs.
