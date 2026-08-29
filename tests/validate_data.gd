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
 if failures.is_empty():print("DATA VALIDATION PASSED: quests, items, enemies, and nonzero damage")
 else:for failure in failures:push_error(failure)
 quit(0 if failures.is_empty() else 1)

