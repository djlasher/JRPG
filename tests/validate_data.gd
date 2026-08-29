extends SceneTree
func _init():
 var failures=[]
 for quest_id in GameState.QUESTS:
  var q=GameState.QUESTS[quest_id]
  if q.type=="defeat_specific" and q.target not in EnemyDatabase.ENEMIES:failures.append("Quest %s references missing enemy %s"%[quest_id,q.target])
 for item_id in GameState.inventory:
  if item_id not in GameState.ITEMS:failures.append("Inventory references missing item "+item_id)
 for id in EnemyDatabase.ENEMIES:
  var e=EnemyDatabase.ENEMIES[id]
  if CombatMath.physical_damage(int(e.attack),25,0)<1:failures.append("Enemy %s produced zero damage"%id)
 var lattice=ProgressionDatabase.build_grid()
 if lattice.size()!=120:failures.append("Advancement lattice has %d nodes, expected 120"%lattice.size())
 for node_id in lattice:
  for linked_id in lattice[node_id].links:
   if not lattice.has(linked_id):failures.append("Lattice node %s links to missing node %s"%[node_id,linked_id])
 var first_drop=ProgressionDatabase.generate_loot("validation_chest",2)
 var second_drop=ProgressionDatabase.generate_loot("validation_chest",2)
 if first_drop!=second_drop:failures.append("Seeded loot generation is not deterministic")
 for slot in ["Weapon","Head","Body","Hands","Feet","Accessory1","Accessory2"]:
  if slot not in GameState.equipment:failures.append("Missing equipment slot "+slot)
 if ProgressionDatabase.SPELLS.size()<16:failures.append("Spell catalog is incomplete")
 if failures.is_empty():print("DATA VALIDATION PASSED: quests, combat, 120-node lattice, spells, loot, and equipment")
 else:for failure in failures:push_error(failure)
 quit(0 if failures.is_empty() else 1)

