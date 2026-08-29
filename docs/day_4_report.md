# Day 4 — Beyond the Last Waylight

## Systems

The job system separates character level/EXP from job level/JP. Eight starting jobs ship: Pathguard, Flame Scholar, Way Mender, Reed Ranger, Lantern Rogue, Stone Monk, Tide Engineer, and Star Priest. Beacon Knight, Spellsteel, and Sky Corsair are advanced jobs; Void Cantor and Starwright are secret jobs. Jobs have roles, stat profiles, level-10 progression storage, unlock tables, clues, and permanently learned skill lists. Final stats follow character baseline × job modifier + equipment.

Relationships use persistent canonical pairs, points, readable tiers, one-time events, and explicit commitment. Ari, Brann, and Lyra are established adults; early bond events never auto-lock romance. A Viridian Accord choice records either `garden_alliance` or `guild_alliance` and changes Lyra's response.

Vehicle progression is Reedrunner ground wagon → Lanternwake boat → Skydart aircraft → Waylight Comet spacecraft. Unlocks/current mode persist and have distinct traversal silhouettes. Space is a controllable 2200×1500 star map rather than a selection screen.

The Waylight Comet has hull, shields, energy, weapons, armor, speed, and upgrades. Its separate turn battle supports fire, shield brace, overcharge, field repair, and flee. Enemy damage uses the shared nonzero formula, shields absorb first, and defeat does not alter the save.

## Destinations

- Viridia: welcoming lattice-garden society and first-contact branch.
- Cyr Ember: saffron desert outpost.
- Orison Moon: quiet low-gravity signal array.
- Cinder Court: functioning Hell city with shops, lodging, a horned archivist, and peaceful residents.

Each has a distinct surface palette, settlement silhouettes, services, discovery state, and return route. Known planets persist. Cinder Court is a society, not an all-hostile dungeon.

## Save and validation

Save version 4 adds job state, unlocked jobs, relationships/events/romance, vehicle state, ship state/upgrades, known planets, and story branches while migrating versions 1–3. Godot 4.6.3 headless editor import completes with no parser/resource errors. Runtime test execution remains blocked by the host's denied `user://logs`; Godot 4.7.2 manual testing is required.

## Known limitations

This enormous milestone is implemented as a coherent foundation, not the full requested content volume. Advanced-job unlock quests, full 8–10 meaningful unlocks per job, equipped cross-job skill combat UI, authored planetary quest chains, job masters, spacecraft interior rooms, multiple ship enemies/boss phases, vehicle-specific terrain masks, planet dungeons, Hell contracts/boss, numerous side quests/secrets, and extended romance/party banter remain incomplete. Boat and aircraft currently reuse surface collision rather than dedicated water/landing rules.

## Playtest route

1. Continue a version 1–3 save and confirm the correct world appears.
2. Open Jobs, change Ari's vocation, fight, and verify JP rises independently while character level remains.
3. Recruit Brann/Lyra, open Bonds, play a one-time event, save/reload, and verify tier/event persistence.
4. Re-enter the Reach between each vehicle discovery to acquire Reedrunner, Lanternwake, Skydart, and Waylight Comet.
5. Launch from Fast Travel, manually pilot the Comet, initiate the voidcraft battle, and verify shield/hull damage is nonzero.
6. Land on Viridia, make the Accord choice, then visit Cyr Ember, Orison, and Cinder Court.
7. Save off-world, quit, Continue, and verify map, position, job, JP, learned skills, relationships, branch, vehicles, ship hull/upgrades, and known planets.

## Milestone 5 priorities

Complete job mastery/unlock quests and inherited-skill selection; build the ship interior; add planet/Hell quest chains, dungeons, bosses, shops, NPCs, bounty boards, terrain-specific vehicle movement, ship crew roles/upgrades, and full automated save matrices under a writable runtime.

