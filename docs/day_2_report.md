# Day 2 — The Lanternvale Reach

## Result and places

Milestone 2 opens Larkspur's south road into **The Lanternvale Reach**, a 2600×1900 region organized around a trade road, rivers, rocky uplands, the Great Stone Arch, ruins, woodland, farms, and optional branches. Milestone 1 remains in place; Larkspur now has an eleventh enterable building, the Wayfarers' Guild.

- **Brackenford** — reed-bridge market town and mining gateway with guild, outfitter, lodging, and Waylight.
- **Mosswick** — compact ferry village on the wet eastern road with its own services and harder postings.
- **Echoing Grotto** — introductory winged-creature cave with branches and treasure.
- **Stillpick Mine** — rocky dungeon containing scout Lio and main boss Stonewarden Orrox.
- **Floodroot Hollow** — dangerous optional lakeside hollow containing rare treasure and the Mire-Crowned Hart.

## Systems and content

`EnemyDatabase` defines Mossling, Briarback, Gloomwing, River Wisp, Stonejaw Burrower, Roadshade, Lantern Moth, Hollow Knight, rare Glass Fox, Stonewarden Orrox, and Mire-Crowned Hart. AI profiles affect attack behavior; bosses persist and cannot be fled.

`BattleUI` provides Attack, Skills, Items, Defend, and Flee, enemy formations, damage, HP/MP, consumable use, enemy turns, victory rewards, EXP/levels, boss flags, and defeat return-to-title handling. Weapon, Armor, and Accessory IDs modify stats through `GameState.stat()`.

Twelve quests ship: Beyond the South Lantern, Pears by the Wayside, Thorns at Highmeadow, Wings Below, A Bottle Before Sundown, The Silent Pick, Light in the Moss, Ink on the Old Road, Lanterns Without Hands, Teeth Beneath Still Water, The Unreturned Scout, and Under the Stone Arch. Boards are settlement-specific; objectives use reusable visit/interact/collect/defeat tracking and Available/Active/Ready/Completed states.

Fourteen persistent treasures cover the road, hidden arch, caves, mine, and optional hollow. Ten discoveries include ghost lights, broken wagon, overlook, ferry camp, old battlefield, singing stone, rare tracks, and an injured traveler.

## Save and important files

Save format 2 adds map ID, equipment, level/EXP, HP/MP, base stats, quests, treasures, bosses, and event IDs. Version 1 saves receive defaults. Read `scripts/core/game_state.gd`, `scripts/world/adventure_map.gd`, `scripts/combat/enemy_database.gd`, `scripts/combat/battle_ui.gd`, and `scripts/core/main.gd` first.

## Validation and limitations

Godot 4.6.3 headless editor import completed without parser or missing-resource errors after implementation. Godot 4.7.2 was unavailable. The sandbox prevents a full headless runtime because Godot cannot create its normal user log directory. Controller focus is assigned on every new menu.

The region favors robust reusable loops over bespoke cutscenes. Destination visuals share a parameterized renderer, Ari remains the sole party member, and Skills currently executes Lantern Cut directly. These are strong Milestone 3 polish candidates.

## Manual checklist / playtest route

1. Verify Larkspur's original shops, interiors, save, and controller behavior; enter its guild and accept Beyond the South Lantern and Wings Below.
2. Leave at South Road, inspect a world event, open Nessa's satchel chest, and fight a visible Mossling/Briarback formation.
3. Exercise Attack, Skill, Item, Defend, and Flee; confirm rewards and level progress.
4. Enter Echoing Grotto, fight Gloomwings, take both treasures, and walk south to return.
5. Reach Brackenford, trigger the visit objective, use guild/outfitter/inn/Waylight, equip an upgrade, and inspect the quest log.
6. Enter Stillpick Mine, find Lio, save, defeat Stonewarden Orrox, and verify it stays defeated after reload.
7. Visit Mosswick, accept Teeth Beneath Still Water, explore Floodroot Hollow, defeat the optional Mire-Crowned Hart, and collect the Wind-knot Brooch.
8. Turn in Ready jobs, save, quit, Continue, and verify position, HP/MP, level/EXP, equipment, quests, treasures, bosses, events, and currency.

## Milestone 3 priorities

Add a second party member, dedicated skill/target submenus, bespoke settlement/interior scenes, animated sprite assets and battle feedback, audio, automated runtime tests with a writable Godot user directory, richer quest-giver dialogue chains, and encounter respawn rules.

