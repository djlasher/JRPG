class_name GameUI
extends CanvasLayer

signal dialogue_closed
signal quit_to_title
signal travel_requested(id:String)
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
 for option in ["Area Map","Party","Jobs","Advancement Lattice","Skills & Magic","Relationships","Bestiary","Fast Travel","Quest Log","Equipment","Return to game","Quit to title"]:
  var b=Button.new(); b.text=option; buttons.add_child(b)
 buttons.get_child(0).pressed.connect(area_map);buttons.get_child(1).pressed.connect(party_menu);buttons.get_child(2).pressed.connect(job_menu);buttons.get_child(3).pressed.connect(advancement_menu);buttons.get_child(4).pressed.connect(magic_menu);buttons.get_child(5).pressed.connect(relationship_menu);buttons.get_child(6).pressed.connect(bestiary_menu);buttons.get_child(7).pressed.connect(fast_travel_menu);buttons.get_child(8).pressed.connect(quest_log);buttons.get_child(9).pressed.connect(equipment_menu);buttons.get_child(10).pressed.connect(_close);buttons.get_child(11).pressed.connect(func():get_tree().paused=false;clear();quit_to_title.emit());buttons.get_child(0).grab_focus()
func advancement_menu():
 _base("Soul-Circuit Lattice",Vector2(590,350),Vector2(25,5));mode="pause";var nodes=ProgressionDatabase.build_grid();body.text="Resonance Marks: %d   Activated: %d/120\nRunic paths carry memory like neon through cathedral glass."%[GameState.lattice_points.get("ari",0),GameState.lattice_active.get("ari",[]).size()]
 var shown=0
 for id in nodes:
  if id in GameState.lattice_active.ari:continue
  var adjacent=false;for active in GameState.lattice_active.ari:if id in nodes[active].links:adjacent=true
  if adjacent and shown<8:var b=Button.new();b.text="%s [%s] — %d Marks"%[nodes[id].name,nodes[id].type,nodes[id].cost];b.pressed.connect(_activate_node.bind(id));buttons.add_child(b);shown+=1
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);buttons.get_child(0).grab_focus()
func _activate_node(id:String):GameState.activate_lattice("ari",id);advancement_menu()
func magic_menu():
 _base("Skills & Encoded Magic",Vector2(570,350),Vector2(35,5));mode="pause";var rows=[]
 for id in GameState.job_state.ari.learned:
  if ProgressionDatabase.SPELLS.has(id):var s=ProgressionDatabase.SPELLS[id];rows.append("[b]%s — %s[/b]  %d MP\n%s; %s. %s"%[s.name,s.school,s.cost,s.target,s.effect,s.get("description","Encoded spell pattern")]);var spell_button=Button.new();spell_button.text="  %s — %s"%[s.name,s.school];spell_button.icon=VisualAssets.icon_for_spell(id);spell_button.icon_max_width=40;buttons.add_child(spell_button)
  else:rows.append("[b]%s[/b] — Job/weapon technique"%str(id).capitalize())
 body.text="\n\n".join(rows);var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);back.grab_focus()
func _inventory_text():
 var out=[]; for id in GameState.inventory: out.append("%s ×%d"%[GameState.ITEMS.get(id,{"name":id}).name,GameState.inventory[id]]); return "\n".join(out)
func area_map():
 _base("Area Map",Vector2(560,340),Vector2(40,10));mode="pause";body.text="Gold: settlements and services   Gray: caves   Blue: water   White: Ari"
 var id=str(GameState.flags.get("map_id","town"));var widget=MapWidget.new();widget.custom_minimum_size=Vector2(500,190);widget.size=Vector2(500,190);widget.setup(id,null,Vector2(2600,1900),false);buttons.add_child(widget)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);back.grab_focus()
func party_menu():
 _base("Party",Vector2(560,340),Vector2(40,10));mode="pause";var rows=[]
 for id in GameState.party:
  if id=="ari":rows.append("[b]Ari — Waylight Warden[/b]\nLv.%d  HP %d/%d  MP %d/%d\nLantern Cut · Ember Spark · Waylight Mend"%[GameState.level,GameState.hp,GameState.stat("max_hp"),GameState.mp,GameState.stat("max_mp")])
  else:var d=GameState.PARTY_DEFS[id];var s=GameState.party_state[id];rows.append("[b]%s — %s[/b]\nLv.%d  HP %d/%d  MP %d/%d\n%s"%[d.name,d.role,s.level,s.hp,s.max_hp,s.mp,s.max_mp," · ".join(d.skills)])
 body.text="\n\n".join(rows);var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);back.grab_focus()
func job_menu():
 _base("Vocation Hall",Vector2(580,350),Vector2(30,5));mode="pause";var js=GameState.job_state.ari;var current=GameState.JOBS[js.current];body.text="Ari's vocation: [b]%s[/b]  Job Lv.%d  JP %d\n%s\nChoose an unlocked vocation; character level remains %d."%[current.name,js.levels[js.current],js.jp[js.current],current.role,GameState.level]
 for id in GameState.unlocked_jobs:
  var job=GameState.JOBS[id];var b=Button.new();b.text="%s — Lv.%d"%[job.name,js.levels.get(id,1)];b.pressed.connect(_change_job.bind(id));buttons.add_child(b)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);buttons.get_child(0).grab_focus()
func _change_job(id:String):GameState.change_job("ari",id);job_menu()
func relationship_menu():
 _base("Bonds",Vector2(540,330),Vector2(50,15));mode="pause";var rows=[]
 for key in GameState.relationships:
  var names=key.split(":");var left=GameState.PARTY_DEFS.get(names[0],{"name":names[0]}).name;var right=GameState.PARTY_DEFS.get(names[1],{"name":names[1]}).name;var record=GameState.relationships[key];rows.append("[b]%s & %s — %s[/b]\n%s"%[left,right,GameState.relationship_tier(key),"Committed romance" if record.romance else "Friendship and trust developing"])
 body.text="\n\n".join(rows)
 for id in ["brann","lyra"]:
  if id in GameState.party and "bond_"+id not in GameState.relationship_events:var event=Button.new();event.text="Spend time with "+GameState.PARTY_DEFS[id].name;event.pressed.connect(_bond_event.bind(id));buttons.add_child(event)
  elif id in GameState.party and int(GameState.relationships["ari:"+id].points)>=30 and not GameState.relationships["ari:"+id].romance:var commit=Button.new();commit.text="Discuss a committed romance with "+GameState.PARTY_DEFS[id].name;commit.pressed.connect(_commit_romance.bind(id));buttons.add_child(commit)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);buttons.get_child(0).grab_focus()
func _bond_event(id:String):GameState.relationship_events.append("bond_"+id);GameState.adjust_relationship("ari:"+id,30);relationship_menu()
func _commit_romance(id:String):GameState.relationships["ari:"+id].romance=true;GameState.relationship_events.append("romance_"+id);relationship_menu()
func bestiary_menu():
 _base("Wayfarers' Bestiary",Vector2(560,340),Vector2(40,10));mode="pause";var rows=[]
 for id in GameState.bestiary:
  var e=EnemyDatabase.ENEMIES.get(id,{});var record=GameState.bestiary[id];rows.append("[b]%s[/b] — Seen %d, Defeated %d\n%s creature; reward %d crowns."%[e.get("name",id),record.seen,record.defeated,e.get("ai","unknown"),e.get("crowns",0)])
 body.text="No creatures recorded." if rows.is_empty() else "\n\n".join(rows);var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);back.grab_focus()
func fast_travel_menu():
 _base("Waylight Travel",Vector2(520,330),Vector2(60,15));mode="pause";body.text="Travel to a discovered Waylight destination."
 for id in GameState.fast_travel:
  var b=Button.new();b.text={"town":"Larkspur","brackenford":"Brackenford","mosswick":"Mosswick","lumenport":"Lumenport","sunstep_abbey":"Sunstep Abbey","space":"Waylight Comet — Launch"}.get(id,id.capitalize());b.pressed.connect(_request_travel.bind(id));buttons.add_child(b)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);buttons.get_child(0).grab_focus()
func _request_travel(id:String):travel_requested.emit(id)
func quest_log():
 _base("Quest Log",Vector2(560,340),Vector2(40,10));mode="pause";var rows=[]
 for id in GameState.quests:
  var q=GameState.QUESTS[id];var s=GameState.quests[id];rows.append("[b][%s] %s — %s[/b]\n%s (%d/%d)\nReward: %d crowns"%[q.category,q.name,s.status,q.description,s.progress,q.count,q.reward.get("crowns",0)])
 body.text="No quests accepted yet. Visit a Wayfarers' Guild board." if rows.is_empty() else "\n\n".join(rows)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);back.grab_focus()
func equipment_menu():
 _base("Equipment Comparison",Vector2(590,350),Vector2(25,5));mode="pause";body.text="Attack %d  Defense %d  Magic %d  Speed %d\nSlots: Weapon · Head · Body · Hands · Feet · Accessory 1 · Accessory 2"%[GameState.stat("attack"),GameState.stat("defense"),GameState.stat("magic"),GameState.stat("speed")]
 for id in GameState.inventory:
  var data=GameState.item_data(id);var slot=str(data.get("slot",data.get("type","")));if slot=="Armor":slot="Body";if slot=="Accessory":slot="Accessory1"
  if slot in GameState.equipment:
   var current=GameState.item_data(GameState.equipment[slot]);var rarity=ProgressionDatabase.RARITIES.get(data.get("rarity","common"),ProgressionDatabase.RARITIES.common);var delta=[];for stat_key in data.get("stats",{}):var change=int(data.stats[stat_key])-int(current.get("stats",{}).get(stat_key,current.get(stat_key,0)));delta.append("%s %+d"%[stat_key.capitalize(),change]);var b=Button.new();b.text="[%s] %s (Rating %d)\n%s: %s  →  %s | %s"%[rarity.name,data.name,data.get("rating",0),slot,current.get("name","Empty"),data.name,", ".join(delta)];b.icon=VisualAssets.icon_for_item(data);b.icon_max_width=44;b.pressed.connect(_equip.bind(id));buttons.add_child(b)
 var back=Button.new();back.text="Back";back.pressed.connect(pause_menu);buttons.add_child(back);buttons.get_child(0).grab_focus()
func _equip_name(slot:String):var id=GameState.equipment.get(slot,"");return "None" if id=="" else GameState.item_data(id).name
func _equip(id:String):GameState.equip_instance(id);equipment_menu()
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
