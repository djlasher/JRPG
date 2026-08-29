# Visual Asset Coverage and Next-Sheet Brief

## Filled from the current sheet

- 11 shipped enemy identities: exploration silhouettes and battle portraits
- 16 encoded spells: menu icons
- 10 weapon archetype icons
- 6 armor/equipment-piece archetypes
- 5 treasure chest tiers
- 9 elemental and 9 ailment symbols reserved in the atlas for the forthcoming combat-status UI
- Equipment comparison rows now display the candidate item silhouette

The four unused monster designs are retained as expansion candidates. Existing enemy IDs and quest targets were not renamed, preventing save and quest regressions.

## Highest-priority missing sheets

### Sheet A — Heroes, party, and NPCs

Create three fully animated top-down JRPG character sheets for Ari, Brann, and Lyra. Each character needs idle and walk cycles facing north, south, east, and west; four frames per walk direction; transparent background; consistent 32×48-pixel cell proportions; no labels. Add 16 distinct civilian NPCs, 8 merchants/service NPCs, and 8 story characters in the same scale and palette. Include separate battle portraits for every named party and story character, with neutral, hurt, joyful, angry, and determined expressions.

### Sheet B — Terrain, architecture, and interiors

Create seamless top-down tiles for grass, long grass, dirt, cobblestone, sand, mud, snow, ash, alien vegetation, lunar stone, infernal basalt, shallow/deep water, rivers, waterfalls, cliffs, cave walls, mine walls, and starship flooring. Use a consistent 32×32 grid with corner/edge/inner-corner variants and transparent transition overlays. Add modular exterior pieces for Larkspur timber homes, Brackenford stone workshops, Mosswick stilt houses, Lumenport canal architecture, Sunstep Abbey, dungeons, starships, three planet settlements, and Cinder Court. Add matching interior floors, walls, doors, windows, counters, beds, shelves, tables, chairs, lamps, stairs, and shop displays.

### Sheet C — Large equipment catalog

Create isolated transparent icons, consistent 96×96 cells, for 20 swords, 12 greatswords, 16 daggers, 16 spears, 12 axes, 12 hammers, 16 bows, 20 staves/wands, 16 rune firearms, and 12 fist/gauntlet weapons. For each family include practical iron/steel, organic/woodland, aquatic/glass, holy/gold, arcane/purple, infernal, alien-tech, and legendary designs. Also create 20 helms/circlets, 20 chest pieces/robes/coats, 16 gloves, 16 leg pieces, 16 boots, 12 cloaks, 24 necklaces/rings/charms, and 12 shields. No text, no frames, no overlapping cells.

### Sheet D — Spell animation frames and combat effects

Create transparent sequential animation strips for fireball, lightning, ice spear, shadow bolt, arcane missile, meteor, shield, barrier, heal, greater heal, protection, reflect, teleport, haste, slow, mana drain, summon gate, scan, poison, bleed, curse, stun, fear, silence, blind, sleep, burn, freeze, and shock. Each effect needs 6–10 frames with consistent anchoring and readable silhouettes at 64×64. Include impact, casting, and lingering-status loops where appropriate.

### Sheet E — Additional monsters and bosses

Create 40 field monsters divided across meadow, forest, river/coast, cave/mine, ruin, city underworld, alien jungle, volcanic planet, moon, space, and infernal regions. Give every creature an exploration sprite, a battle sprite, a 6-frame attack, a 4-frame hurt/death sequence, and one distinct status silhouette. Add 12 screen-filling bosses with neutral, attack, special, stagger, and defeat frames. Keep all cells text-free and transparent.

### Sheet F — World objects, vehicles, and maps

Create top-down sprites for waylights, guild boards, quest markers, treasure variants, harvest nodes, switches, gates, bridges, boats, carts, the Skydart aircraft, the Waylight Comet spacecraft, enemy ships, planet markers, cave entrances, mines, towns, abbeys, observatories, and dimensional gates. Include minimap-scale companion icons with high-contrast silhouettes.

## Still unfilled after those sheets

- Title-screen illustration and logo treatment
- Dialogue-box ornaments, button glyphs, controller prompts, cursors, and focus states
- Character paper-doll previews for equipped armor
- Shopkeeper counter animations and inn/rest vignettes
- Quest-item icons, consumables, crafting materials, currencies, and key items
- Weather overlays, day/night lighting masks, water animation, foliage motion, smoke, dust, sparks, and footprints
- Cutscene backgrounds, romance-event illustrations, ending cards, and credits art
- Ship module icons, ship weapons, shields, hull-damage effects, and cockpit UI
- Portraits and architecture for every planet/Hell faction
- Accessibility variants for status/element icons that remain distinguishable without color

## Production constraints for every follow-up sheet

Use the established jewel-lit dark-fantasy JRPG style, but keep gameplay silhouettes readable at the 640×360 internal resolution. Use genuinely transparent backgrounds, fixed grid cells, generous padding, no labels, no watermarks, no UI mockup frames, and no assets crossing cell boundaries. Provide a separate manifest listing row, column, subject ID, frame count, anchor point, and intended runtime size.
