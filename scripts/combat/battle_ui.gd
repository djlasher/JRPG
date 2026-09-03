class_name BattleUI
extends CanvasLayer
signal battle_finished(victory:bool,enemy_id:String)
var enemies:Array[Dictionary]=[]
var enemy_id:String
var panel:PanelContainer
var info:RichTextLabel
var commands:GridContainer
var portraits:Array[Control]=[]
var damage_flash:ColorRect
var defending:=false
var locked:=false
var submenu:=false
func setup(id:String):enemy_id=id
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().paused=true
 for id in EnemyDatabase.formation(enemy_id):var enemy=EnemyDatabase.ENEMIES[id].duplicate();enemy.id=id;enemy.current_hp=enemy.hp;enemies.append(enemy);GameState.discover_enemy(id)
 _build();_show_commands();_refresh("Enemies block the road — choose an action.")
func _build():
 var bg=ColorRect.new();bg.color=Color("101522");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 var portrait_row=HBoxContainer.new();portrait_row.position=Vector2(80,8);portrait_row.size=Vector2(480,166);portrait_row.alignment=BoxContainer.ALIGNMENT_CENTER;portrait_row.add_theme_constant_override("separation",18);add_child(portrait_row)
 for enemy in enemies:var portrait=EnemyPortrait.new();portrait.setup(enemy.id,Color(enemy.color));portrait.tooltip_text=enemy.name;portrait_row.add_child(portrait);portraits.append(portrait)
 panel=PanelContainer.new();panel.position=Vector2(20,178);panel.size=Vector2(600,172);add_child(panel);var row=HBoxContainer.new();panel.add_child(row);info=RichTextLabel.new();info.bbcode_enabled=true;info.custom_minimum_size=Vector2(392,154);row.add_child(info);commands=GridContainer.new();commands.columns=2;commands.custom_minimum_size=Vector2(185,154);row.add_child(commands)
 damage_flash=ColorRect.new();damage_flash.color=Color(0.75,0.02,0.02,0);damage_flash.mouse_filter=Control.MOUSE_FILTER_IGNORE;damage_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(damage_flash)
func _button(label:String,callback:Callable,icon:Texture2D=null):
 var button=Button.new();button.text=label;button.pressed.connect(callback)
 if icon:
  button.icon=icon
  button.icon_max_width=28
 commands.add_child(button)
func _clear_commands():for child in commands.get_children():child.queue_free()
func _show_commands():
 submenu=false;_clear_commands();_button("ATTACK",_attack);_button("SKILLS",_skills_menu);_button("MAGIC",_magic_menu);_button("ITEMS",_items_menu);_button("DEFEND",_defend);_button("FLEE",_flee);await get_tree().process_frame;if commands.get_child_count()>0:commands.get_child(0).grab_focus()
func _show_submenu(title_text:String):submenu=true;_clear_commands();_refresh(title_text)
func _skills_menu():
 if locked:return
 _show_submenu("Choose a technique. Skills use physical power; Magic has its own command.");var added=0
 for id in GameState.job_state.ari.learned:
  if ProgressionDatabase.SPELLS.has(id):continue
  var skill=GameState.SKILLS.get(id,{});if skill.is_empty():continue
  _button("%s — %d MP"%[skill.name,skill.cost],_use_skill.bind(id));added+=1
 if added==0:_button("No techniques learned",func():pass)
 _button("BACK",_show_commands);await get_tree().process_frame;commands.get_child(0).grab_focus()
func _magic_menu():
 if locked:return
 _show_submenu("Choose an encoded spell. Elemental magic uses Ari's Magic stat.");var spell_ids:Array[String]=[]
 if "ember_spark" in GameState.PARTY_DEFS.ari.skills:spell_ids.append("ember_spark")
 for id in GameState.job_state.ari.learned:if ProgressionDatabase.SPELLS.has(id) and id not in spell_ids:spell_ids.append(id)
 for id in spell_ids:
  if id=="ember_spark":_button("Ember Spark — 6 MP",_use_legacy_magic.bind(id))
  else:var spell=ProgressionDatabase.SPELLS.get(id,{});if not spell.is_empty():_button("%s — %d MP"%[spell.get("name",id.capitalize()),spell.get("cost",0)],_use_magic.bind(id))
 _button("BACK",_show_commands);await get_tree().process_frame;commands.get_child(0).grab_focus()
func _items_menu():
 if locked:return
 _show_submenu("Choose a carried item.");var added=0
 for id in GameState.inventory:
  var item=GameState.ITEMS.get(id,{})
  if item.get("type","")!="Consumable" or int(GameState.inventory[id])<1:continue
  _button("%s ×%d"%[item.name,GameState.inventory[id]],_use_item.bind(id));added+=1
 if added==0:_button("No usable items",func():pass)
 _button("BACK",_show_commands);await get_tree().process_frame;commands.get_child(0).grab_focus()
func _refresh(message:String):
 var rows=[];for enemy in enemies:if enemy.current_hp>0:rows.append("%s  HP %d/%d"%[enemy.name,maxi(0,enemy.current_hp),enemy.hp])
 var party_rows=[]
 for id in GameState.party:
  if id=="ari":party_rows.append("Ari Lv.%d  HP %d/%d  MP %d/%d"%[GameState.level,GameState.hp,GameState.stat("max_hp"),GameState.mp,GameState.stat("max_mp")])
  else:var state=GameState.party_state[id];party_rows.append("%s  HP %d/%d  MP %d/%d"%[GameState.PARTY_DEFS[id].name,state.hp,state.max_hp,state.mp,state.max_mp])
 info.text="[b]%s[/b]\n%s\n\n%s"%[message,"\n".join(rows),"\n".join(party_rows)]
func _living():return enemies.filter(func(enemy):return enemy.current_hp>0)
func _attack():
 if locked:return
 var target=_living()[0];var damage:=CombatMath.physical_damage(GameState.stat("attack"),int(target.defense),randi_range(-2,2));target.current_hp-=damage;_track_defeat(target);_flash_enemy(enemies.find(target));_after_player("Ari strikes %s for %d damage!"%[target.name,damage])
func _use_skill(id:String):
 var skill=GameState.SKILLS[id];var cost=int(skill.cost)
 if GameState.mp<cost:_refresh("Not enough MP for %s."%skill.name);return
 GameState.mp-=cost
 if skill.kind=="heal":var restored=mini(int(skill.power),GameState.stat("max_hp")-GameState.hp);GameState.hp+=restored;_after_player("%s restores %d HP."%[skill.name,restored]);return
 var target=_living()[0];var damage=CombatMath.skill_damage(GameState.stat("attack"),float(skill.power),int(target.defense),1);target.current_hp-=damage;_track_defeat(target);_flash_enemy(enemies.find(target));_after_player("%s deals %d damage to %s!"%[skill.name,damage,target.name])
func _use_legacy_magic(id:String):
 if locked or _living().is_empty():return
 var spell:Dictionary=GameState.SKILLS.get(id,{})
 if spell.is_empty():_refresh("That spell pattern is unavailable.");return
 var cost=int(spell.get("cost",0));var spell_name=str(spell.get("name",id.capitalize()))
 if GameState.mp<cost:_refresh("Not enough MP for %s."%spell_name);return
 GameState.mp-=cost;var target:Dictionary=_living()[0];var damage=CombatMath.skill_damage(maxi(1,GameState.stat("magic")),float(spell.get("power",1.0)),int(target.get("defense",0)),2);target.current_hp=int(target.current_hp)-damage;_track_defeat(target);_flash_enemy(enemies.find(target));call_deferred("_after_player","%s erupts for %d damage!"%[spell_name,damage])
func _use_magic(id:String):
 if locked:return
 var spell:Dictionary=ProgressionDatabase.SPELLS.get(id,{})
 if spell.is_empty():_refresh("That spell pattern is unavailable.");return
 var cost=int(spell.get("cost",0));var spell_name=str(spell.get("name",id.capitalize()))
 if GameState.mp<cost:_refresh("Not enough MP for %s."%spell_name);return
 GameState.mp-=cost
 if float(spell.get("power",0))<=0:call_deferred("_after_player","%s activates: %s."%[spell_name,spell.get("effect","Runic field")]);return
 if _living().is_empty():return
 var target:Dictionary=_living()[0];var damage=CombatMath.skill_damage(maxi(1,GameState.stat("magic")),float(spell.get("power",1.0)),int(target.get("defense",0)),2);target.current_hp=int(target.current_hp)-damage;_track_defeat(target);_flash_enemy(enemies.find(target));call_deferred("_after_player","%s deals %d damage — %s."%[spell_name,damage,spell.get("effect","Arcane impact")])
func _use_item(id:String):
 var item=GameState.ITEMS[id]
 if int(GameState.inventory.get(id,0))<1:return
 GameState.inventory[id]-=1;var healed_hp=mini(int(item.get("hp",0)),GameState.stat("max_hp")-GameState.hp);var healed_mp=mini(int(item.get("mp",0)),GameState.stat("max_mp")-GameState.mp);GameState.hp+=healed_hp;GameState.mp+=healed_mp;_after_player("Ari uses %s: +%d HP, +%d MP."%[item.name,healed_hp,healed_mp])
func _track_defeat(target:Dictionary):if target.current_hp<=0:GameState.track("defeat_specific",target.id);GameState.discover_enemy(target.id,true)
func _defend():if not locked:defending=true;_after_player("Ari braces. Incoming damage is heavily reduced this turn.")
func _flee():
 if EnemyDatabase.ENEMIES[enemy_id].get("boss",false):_refresh("There is no escape from this foe.");return
 get_tree().paused=false;battle_finished.emit(false,enemy_id);queue_free()
func _after_player(message:String):
 locked=true;submenu=false;_clear_commands();message+=_allies_act();_refresh(message)
 if _living().is_empty():await get_tree().create_timer(.55,true).timeout;_victory();return
 await get_tree().create_timer(.65,true).timeout;_enemy_turn()
func _allies_act()->String:
 var text=""
 for id in GameState.party:
  if id=="ari" or _living().is_empty():continue
  var member=GameState.party_state[id]
  if int(member.hp)<=0:continue
  var target=_living()[0];var damage:=CombatMath.physical_damage(int(member.attack),int(target.defense),0);if id=="lyra":damage=CombatMath.skill_damage(int(member.magic),1.35,int(target.defense));target.current_hp-=damage;text+="\n%s acts for %d damage."%[GameState.PARTY_DEFS[id].name,damage];_track_defeat(target);_flash_enemy(enemies.find(target))
 return text
func _enemy_turn():
 var total=0;var living_party=[]
 for id in GameState.party:var member_hp=GameState.hp if id=="ari" else int(GameState.party_state[id].hp);if member_hp>0:living_party.append(id)
 for index in _living().size():
  var enemy=_living()[index]
  if living_party.is_empty():break
  var target_id:String=living_party[index%living_party.size()];var target_defense=GameState.stat("defense") if target_id=="ari" else int(GameState.party_state[target_id].defense);var raw=CombatMath.physical_damage(int(enemy.attack),target_defense,randi_range(-2,1));var scale=.70 if enemy.get("boss",false) else .52;var damage=maxi(1,int(round(raw*scale)));if defending:damage=maxi(1,int(round(damage*.35)))
  _enemy_attack_feedback(enemies.find(enemy));await get_tree().create_timer(.18,true).timeout
  if target_id=="ari":GameState.hp=maxi(0,GameState.hp-damage)
  else:GameState.party_state[target_id].hp=maxi(0,int(GameState.party_state[target_id].hp)-damage)
  total+=damage
 defending=false;var survivors=GameState.hp;for id in GameState.party:if id!="ari":survivors+=int(GameState.party_state[id].hp)
 if survivors<=0:_refresh("The party falls beneath the onslaught.");await get_tree().create_timer(.8,true).timeout;get_tree().paused=false;battle_finished.emit(false,"game_over");queue_free();return
 locked=false;_refresh("Enemy turn deals %d total damage. Choose the next action."%total);_show_commands()
func _flash_enemy(index:int):
 if index<0 or index>=portraits.size():return
 var portrait=portraits[index];var tween=create_tween();tween.tween_property(portrait,"modulate",Color(2,2,2,1),.08);tween.tween_property(portrait,"modulate",Color.WHITE,.16)
func _enemy_attack_feedback(index:int):
 if index>=0 and index<portraits.size():var portrait=portraits[index];var start=portrait.position;var tween=create_tween();tween.tween_property(portrait,"position",start+Vector2(0,12),.08);tween.tween_property(portrait,"position",start,.12)
 var flash=create_tween();flash.tween_property(damage_flash,"color:a",.34,.05);flash.tween_property(damage_flash,"color:a",0.0,.22)
func _victory():
 var exp=0;var money=0;for enemy in enemies:exp+=int(enemy.exp);money+=int(enemy.crowns)
 var notes=GameState.gain_rewards(exp,money);GameState.gain_job_points(maxi(8,exp/3));for member_id in GameState.party:GameState.lattice_points[member_id]=int(GameState.lattice_points.get(member_id,0))+maxi(1,exp/25);for enemy in enemies:GameState.discover_enemy(enemy.id,true);if EnemyDatabase.ENEMIES[enemy_id].get("boss",false) and enemy_id not in GameState.defeated_bosses:GameState.defeated_bosses.append(enemy_id)
 var recovery=maxi(8,int(GameState.stat("max_hp")*.18));GameState.hp=mini(GameState.stat("max_hp"),GameState.hp+recovery);GameState.mp=mini(GameState.stat("max_mp"),GameState.mp+3);_refresh("Victory! %d EXP, %d crowns, +%d HP, +3 MP. %s"%[exp,money,recovery," ".join(notes)]);await get_tree().create_timer(1.5,true).timeout;get_tree().paused=false;battle_finished.emit(true,enemy_id);queue_free()
func _unhandled_input(event):
 if submenu and event.is_action_pressed("cancel"):_show_commands();get_viewport().set_input_as_handled()

