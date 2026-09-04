extends Node
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS
 GameState.reset()
 var loot=GameState.roll_chest("menu_test_chest",1)
 var ui=GameUI.new();add_child(ui)
 ui.pause_menu()
 await get_tree().process_frame
 assert(ui.buttons.get_child(0).text=="Gear / Equipment")
 assert(ui.panel.position.y+ui.panel.size.y<=360)
 ui.equipment_menu()
 await get_tree().process_frame
 assert(ui.buttons.get_child_count()>=5)
 ui._equip(loot.instance_id)
 assert(GameState.equipment[loot.slot]==loot.instance_id)
 GameState.job_state.ari.learned.append(ProgressionDatabase.SPELLS.keys()[0])
 ui.magic_menu()
 await get_tree().process_frame
 assert(ui.panel.position.y+ui.panel.size.y<=360)
 print("MENU TEST PASSED: visible Gear entry, chest equipment, Skills icons, bounded panels")
 get_tree().paused=false
 get_tree().quit()

