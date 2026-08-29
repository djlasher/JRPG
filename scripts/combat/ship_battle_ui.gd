class_name ShipBattleUI
extends CanvasLayer
signal finished(victory:bool)
var enemy_hp:=150
var guarding:=false
var info:RichTextLabel
var buttons:VBoxContainer
func _ready():process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().paused=true;var bg=ColorRect.new();bg.color=Color("070b20");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg);var p=PanelContainer.new();p.position=Vector2(45,55);p.size=Vector2(550,270);add_child(p);var h=HBoxContainer.new();p.add_child(h);info=RichTextLabel.new();info.bbcode_enabled=true;info.custom_minimum_size=Vector2(350,240);h.add_child(info);buttons=VBoxContainer.new();h.add_child(buttons);for label in ["FIRE LANCES","SHIELD BRACE","OVERCHARGE","FIELD REPAIR","FLEE"]:var b=Button.new();b.text=label;buttons.add_child(b);buttons.get_child(0).pressed.connect(_fire);buttons.get_child(1).pressed.connect(_guard);buttons.get_child(2).pressed.connect(_overcharge);buttons.get_child(3).pressed.connect(_repair);buttons.get_child(4).pressed.connect(_flee);buttons.get_child(0).grab_focus();_refresh("Hostile voidcraft intercepts the Waylight Comet.")
func _refresh(text:String):info.text="[b]%s[/b]\n\nEnemy Hull %d/150\n\n%s\nHull %d/%d  Shields %d/%d  Energy %d"%[text,enemy_hp,GameState.ship.name,GameState.ship.hull,GameState.ship.max_hull,GameState.ship.shields,GameState.ship.max_shields,GameState.ship.energy]
func _fire():enemy_hp-=int(GameState.ship.weapons);_after("Lances strike for %d hull damage."%GameState.ship.weapons)
func _guard():guarding=true;GameState.ship.shields=mini(GameState.ship.max_shields,int(GameState.ship.shields)+18);_after("Shields rise in a blue arc.")
func _overcharge():
 if int(GameState.ship.energy)<15:_refresh("Insufficient energy.");return
 GameState.ship.energy-=15;enemy_hp-=int(GameState.ship.weapons)*2;_after("Overcharge tears through the enemy for %d."%(int(GameState.ship.weapons)*2))
func _repair():GameState.ship.hull=mini(GameState.ship.max_hull,int(GameState.ship.hull)+35);_after("The engineering crew restores 35 hull.")
func _flee():get_tree().paused=false;finished.emit(false);queue_free()
func _after(message:String):
 _refresh(message)
 if enemy_hp<=0:await get_tree().create_timer(.6,true).timeout;GameState.crowns+=180;if "pulse_lance" not in GameState.ship.upgrades:GameState.ship.upgrades.append("pulse_lance");get_tree().paused=false;finished.emit(true);queue_free();return
 await get_tree().create_timer(.45,true).timeout;var damage=CombatMath.physical_damage(24,int(GameState.ship.armor),1);if guarding:damage=maxi(1,damage/2);guarding=false;var shield_hit=mini(int(GameState.ship.shields),damage);GameState.ship.shields-=shield_hit;GameState.ship.hull=maxi(0,int(GameState.ship.hull)-(damage-shield_hit));_refresh("Enemy batteries deal %d damage."%damage);if int(GameState.ship.hull)<=0:get_tree().paused=false;finished.emit(false);queue_free()

