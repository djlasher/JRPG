class_name GameUI
extends CanvasLayer

signal dialogue_closed
signal quit_to_title
var panel:PanelContainer
var title:Label
var body:RichTextLabel
var pages:Array[String]=[]
var page:=0
var mode:=""
var buttons:VBoxContainer
var owner_main:Node

func _ready(): process_mode=Node.PROCESS_MODE_ALWAYS
func clear(): if panel: panel.queue_free(); panel=null; mode=""
func _base(caption:String,size:=Vector2(560,150),pos:=Vector2(40,190)):
 clear(); panel=PanelContainer.new(); panel.position=pos; panel.size=size; var style=StyleBoxFlat.new(); style.bg_color=Color("17223bdd"); style.border_color=Color("d5af63"); style.set_border_width_all(3); style.corner_radius_top_left=8; style.corner_radius_top_right=8; style.corner_radius_bottom_left=8; style.corner_radius_bottom_right=8; panel.add_theme_stylebox_override("panel",style); add_child(panel)
 var v=VBoxContainer.new(); v.add_theme_constant_override("separation",8); panel.add_child(v); title=Label.new(); title.text=caption; title.add_theme_color_override("font_color",Color("f0c96b")); title.add_theme_font_size_override("font_size",18); v.add_child(title); body=RichTextLabel.new(); body.bbcode_enabled=true; body.fit_content=true; body.custom_minimum_size=Vector2(size.x-30,60); v.add_child(body); buttons=VBoxContainer.new(); v.add_child(buttons)
func dialogue(name:String,texts:Array,actor=null):
 _base(name); pages.clear(); for t in texts: pages.append(str(t)); page=0; body.text=pages[0]; mode="dialogue"; if actor: actor.talking=true; panel.set_meta("actor",actor)
func feedback(text:String): dialogue("",[text])
func shop(id:String,name:String):
 _base(name,Vector2(560,300),Vector2(40,30)); mode="shop"; body.text="Choose an item.  Crowns: %d"%GameState.crowns
 var stock=["sunleaf_tonic","clearwater_salt","lantern_charm"] if id=="general" else (["marsh_blade","quarry_mail","wind_knot","sunleaf_tonic"] if "Brackenford" in name or "Mosswick" in name else ["reed_sword","ash_staff","wayfarer_vest"])
 for item_id in stock:
  var d=GameState.ITEMS[item_id]; var b=Button.new(); b.text="%s — %d crowns\n%s"%[d.name,d.price,d.description]; b.pressed.connect(_buy.bind(item_id,int(d.price))); buttons.add_child(b)
 var close=Button.new(); close.text="Leave shop"; close.pressed.connect(_close); buttons.add_child(close); buttons.get_child(0).grab_focus()
func _buy(id:String,price:int): body.text=("Purchased %s.  Crowns: %d"%[GameState.ITEMS[id].name,GameState.crowns] if GameState.buy(id,price) else "You do not have enough crowns.")
func inn():
 _base("Maeve",Vector2(500,220),Vector2(70,80)); mode="menu"; body.text="A room and warm breakfast cost 24 crowns. Rest?"
 for option in ["Rest — 24 crowns","Not tonight"]:
  var b=Button.new();b.text=option;buttons.add_child(b)
 buttons.get_child(0).pressed.connect(_rest); buttons.get_child(1).pressed.connect(_close); buttons.get_child(0).grab_focus()
func _rest():
 if GameState.crowns>=24: GameState.crowns-=24;GameState.hp=GameState.stat("max_hp");GameState.mp=GameState.stat("max_mp");body.text="The lamps dim. You wake fully restored beneath a quilt of blue herons.";for c in buttons.get_children():c.queue_free()
 else: body.text="Maeve smiles gently. 'Come back when the road has been kinder.'"
func pause_menu():
 _base("Travel Journal",Vector2(560,340),Vector2(40,10));mode="pause";get_tree().paused=true;var mins=int(GameState.play_seconds)/60;body.text="[b]%s — Level %d[/b]  HP %d/%d  MP %d/%d\nLocation: %s  Crowns: %d  Journey: %02d:%02d\n%s"%[GameState.HERO_NAME,GameState.level,GameState.hp,GameState.stat("max_hp"),GameState.mp,GameState.stat("max_mp"),GameState.current_location,GameState.crowns,mins,int(GameState.play_seconds)%60,_inventory_text()]
 for option in ["Quest Log","Equipment","Return to game","Quit to title"]:
  var b=Button.new(); b.text=option; buttons.add_child(b)
 buttons.get_child(0).pressed.connect(quest_log);buttons.get_child(1).pressed.connect(equipment_menu);buttons.get_child(2).pressed.connect(_close);buttons.get_child(3).pressed.connect(func():get_tree().paused=false;clear();quit_to_title.emit());buttons.get_child(0).grab_focus()
func _inventory_text():
 var out=[]; for id in GameState.inventory: out.append("%s ×%d"%[GameState.ITEMS.get(id,{"name":id}).name,GameState.inventory[id]]); return "\n".join(out)
func quest_log():
 _base("Quest Log",Vector2(560,340),Vector2(40,10));mode="pause";var rows=[]
 for id in GameState.quests:
  var q=GameState.QUESTS[id];var s=GameState.quests[id];rows.append("[b][%s] %s — %s[/b]\n%s (%d/%d)\nReward: %d crowns"%[q.category,q.name,s.status,q.description,s.progress,q.count,q.reward.get("crowns",0)])
 body.text="No quests accepted yet. Visit a Wayfarers' Guild board." if rows.is_empty() else "\n\n".join(rows)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);back.grab_focus()
func equipment_menu():
 _base("Equipment",Vector2(560,340),Vector2(40,10));mode="pause";body.text="Attack %d  Defense %d  Magic %d  Speed %d\nWeapon: %s\nArmor: %s\nAccessory: %s"%[GameState.stat("attack"),GameState.stat("defense"),GameState.stat("magic"),GameState.stat("speed"),_equip_name("Weapon"),_equip_name("Armor"),_equip_name("Accessory")]
 for id in GameState.inventory:
  if GameState.ITEMS.get(id,{}).get("type","") in GameState.equipment:
   var b=Button.new();b.text="Equip "+GameState.ITEMS[id].name;b.pressed.connect(_equip.bind(id));buttons.add_child(b)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);buttons.get_child(0).grab_focus()
func _equip_name(slot:String):var id=GameState.equipment[slot];return "None" if id=="" else GameState.ITEMS[id].name
func _equip(id:String):GameState.equip(id);equipment_menu()
func guild_board(town:String):
 _base("Wayfarers' Guild Board",Vector2(560,340),Vector2(40,10));mode="menu";body.text="Select a posted job. Active jobs can be turned in when ready."
 var ids=["first_road","cave_wings","lost_satchel"] if town=="larkspur" else (["thorn_problem","bandit_ledgers","missing_scout","mine_silence"] if town=="brackenford" else ["moon_moss","ruin_lights","lake_beast","medicine_run","old_arch"])
 for id in ids:
  var q=GameState.QUESTS[id];var b=Button.new();b.text="%s — %s"%[q.name,GameState.quests.get(id,{"status":"Available"}).status];b.pressed.connect(_quest_action.bind(id,town));buttons.add_child(b)
 var close=Button.new();close.text="Leave board";close.pressed.connect(_close);buttons.add_child(close);buttons.get_child(0).grab_focus()
func _quest_action(id:String,town:String):
 if not GameState.quests.has(id):GameState.accept_quest(id);body.text="Quest accepted: "+GameState.QUESTS[id].name
 elif GameState.turn_in(id):body.text="Quest complete. The guild records your service and pays the reward."
 else:body.text="Progress: %d/%d"%[GameState.quests[id].progress,GameState.QUESTS[id].count]
func _unhandled_input(event):
 if not panel: return
 if mode=="dialogue" and (event.is_action_pressed("confirm") or event.is_action_pressed("interact")):
  page+=1
  if page<pages.size(): body.text=pages[page]
  else: _close()
 elif event.is_action_pressed("cancel") and mode!="pause": _close()
func _close():
 var actor=panel.get_meta("actor",null) if panel else null; if actor: actor.talking=false
 if mode=="pause": get_tree().paused=false
 clear(); dialogue_closed.emit()

