# Day 3 — Seven Lamps Chapter

## Stabilization

Continue loaded the saved world behind the title canvas; only the higher-layer minimap was visible. `Main` now removes that canvas before restoring the saved map and position. The generic three-house map fallback was replaced by explicit geography/markers for every current map ID.

Combat now routes attacks through `CombatMath`: `max(1, attack - floor(defense × 0.35) + variance)`. Battle text reports actual damage and HP. The integrity script checks every enemy against defense 25 and rejects zero damage.

## Additions

- Party: Ari (balanced Waylight Warden), Captain Brann (defensive captain), and Lyra Vale (fast Tide Scholar). Brann recruits in Brackenford; Lyra recruits in Lumenport. Party state persists.
- Party battles: allies act each round; enemies distribute nonzero attacks across living members; the whole party must fall for defeat.
- Lumenport: Lantern Market, Grand Guild, High Temple, River Inn, Beacon Hall, Arsenal, Apothecary, canals, bridges, and waterfront.
- Sunstep Abbey: specialized mirror-pool settlement.
- Tideglass Aqueduct and Fallen Observatory: new destinations with persistent gate/lens puzzle keys and boss routes.
- Journal: Party, Bestiary, Fast Travel, Map, Quests, Equipment, and status, all with controller focus.
- Navigation: map-specific minimaps/full maps, nine distinct regional destinations, discovery persistence, and Waylight fast travel.
- Save v3: party, member stats, bestiary, discoveries, travel unlocks, puzzle state, and guild reputation; versions 1–2 migrate.

## Validation and limitations

Godot 4.6.3 headless editor import completes without script/resource errors; 4.7.2 is unavailable. `tests/validate_data.gd` checks quest enemy references, inventory IDs, and nonzero damage. The sandbox blocks Godot's normal runtime log directory, so disk-save/controller matrices remain manual.

Party allies currently act automatically after Ari instead of receiving individual command menus. Full elemental weakness/status/buff UX, bespoke interiors for every Lumenport building, extended quest chains, and staged cutscenes remain incomplete. Puzzle mechanisms are persistent interactions rather than multi-room physics sequences.

## Test route

1. Save in Larkspur, quit, Continue, and confirm the world appears at the saved position.
2. Compare Reach, Brackenford, Grotto, Mine, and Mosswick maps; none should show the same template.
3. Fight several enemy families and confirm enemy turns visibly reduce party HP by at least 1.
4. Recruit Brann, save/reload, then recruit Lyra in Lumenport and repeat.
5. Verify Bestiary entries and fast travel unlocks.
6. Visit Lumenport, Sunstep Abbey, Tideglass Aqueduct, and Fallen Observatory; activate puzzle keys and save/reload.
7. Regress Milestone 1 shops/inn/church/guild and Milestone 2 quests/treasure/bosses.

## Next priorities

Give every party member a command/target turn; complete elements, buffs/debuffs/statuses and skill unlocking; add city interiors/NPCs, quest chains/cutscenes, audio/visual effects, and automated save matrices in a writable runtime environment.

