class_name BattleUI
extends CanvasLayer
signal battle_finished(victory:bool,enemy_id:String)
var enemies:Array[Dictionary]=[]
var enemy_id:String
var panel:PanelContainer
var info:RichTextLabel
var commands:VBoxContainer
var defending:=false
var locked:=false
func setup(id:String):enemy_id=id
func _ready():process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().paused=true;_build();for id in EnemyDatabase.formation(enemy_id):var e=EnemyDatabase.ENEMIES[id].duplicate();e.id=id;e.current_hp=e.hp;enemies.append(e);_refresh("Enemies block the road!")
func _build():
 var bg=ColorRect.new();bg.color=Color("1b2438");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 panel=PanelContainer.new();panel.position=Vector2(25,190);panel.size=Vector2(590,150);add_child(panel);var h=HBoxContainer.new();panel.add_child(h);info=RichTextLabel.new();info.bbcode_enabled=true;info.custom_minimum_size=Vector2(360,130);h.add_child(info);commands=VBoxContainer.new();h.add_child(commands)
 for label in ["ATTACK","SKILLS","ITEMS","DEFEND","FLEE"]:var b=Button.new();b.text=label;commands.add_child(b)
 commands.get_child(0).pressed.connect(_attack);commands.get_child(1).pressed.connect(_skills);commands.get_child(2).pressed.connect(_item);commands.get_child(3).pressed.connect(_defend);commands.get_child(4).pressed.connect(_flee);commands.get_child(0).grab_focus()
func _refresh(message:String):
 var rows=[];for e in enemies:if e.current_hp>0:rows.append("%s  HP %d/%d"%[e.name,e.current_hp,e.hp])
 info.text="[b]%s[/b]\n%s\n\nAri Lv.%d  HP %d/%d  MP %d/%d"%[message,"\n".join(rows),GameState.level,GameState.hp,GameState.stat("max_hp"),GameState.mp,GameState.stat("max_mp")]
func _living():return enemies.filter(func(e):return e.current_hp>0)
func _attack():
 if locked:return
 var target=_living()[0];var raw:int=GameState.stat("attack")-int(target.defense)/2+randi_range(-2,2);var damage:int=clampi(raw,1,999);target.current_hp-=damage;GameState.track("defeat_specific",target.id,1 if target.current_hp<=0 else 0);_after_player("Ari strikes %s for %d!"%[target.name,damage])
func _skills():
 if locked:return
 if GameState.mp<4:_refresh("Not enough MP.");return
 GameState.mp-=4;var target=_living()[0];var damage=max(2,int(GameState.stat("attack")*1.6)-int(target.defense)/2);target.current_hp-=damage;GameState.track("defeat_specific",target.id,1 if target.current_hp<=0 else 0);_after_player("Lantern Cut deals %d to %s!"%[damage,target.name])
func _item():
 if locked:return
 if GameState.inventory.get("sunleaf_tonic",0)<1:_refresh("No Sunleaf Tonics remain.");return
 GameState.inventory.sunleaf_tonic-=1;GameState.hp=min(GameState.stat("max_hp"),GameState.hp+35);_after_player("Ari drinks a tonic and recovers 35 HP.")
func _defend():defending=true;_after_player("Ari braces behind a steady guard.")
func _flee():
 if EnemyDatabase.ENEMIES[enemy_id].get("boss",false):_refresh("There is no escape from this foe.");return
 get_tree().paused=false;battle_finished.emit(false,enemy_id);queue_free()
func _after_player(message:String):
 locked=true;_refresh(message)
 if _living().is_empty():await get_tree().create_timer(.5,true).timeout;_victory();return
 await get_tree().create_timer(.45,true).timeout;_enemy_turn()
func _enemy_turn():
 var total=0
 for e in _living():
  var power:int=int(e.attack)+(4 if e.ai in ["aggressive","boss"] else 0);var raw:int=power-int(GameState.stat("defense")*0.35)+randi_range(-1,3);var damage:int=clampi(raw,1,999);if defending:damage=maxi(1,damage/2);GameState.hp=maxi(0,GameState.hp-damage);total+=damage
 defending=false
 if GameState.hp<=0:GameState.hp=0;_refresh("Ari falls beneath the onslaught.");await get_tree().create_timer(.8,true).timeout;get_tree().paused=false;battle_finished.emit(false,"game_over");queue_free();return
 locked=false;_refresh("The enemy turn deals %d total damage."%total);commands.get_child(0).grab_focus()
func _victory():
 var exp=0;var money=0;for e in enemies:exp+=int(e.exp);money+=int(e.crowns)
 var notes=GameState.gain_rewards(exp,money);if EnemyDatabase.ENEMIES[enemy_id].get("boss",false) and enemy_id not in GameState.defeated_bosses:GameState.defeated_bosses.append(enemy_id)
 _refresh("Victory! %d EXP and %d crowns. %s"%[exp,money," ".join(notes)]);await get_tree().create_timer(1.2,true).timeout;get_tree().paused=false;battle_finished.emit(true,enemy_id);queue_free()

