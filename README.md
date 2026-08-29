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

